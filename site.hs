--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}

import Data.Monoid (mappend)
import Hakyll
import Text.Pandoc.Options
import Data.Time.Format (defaultTimeLocale, formatTime)

--------------------------------------------------------------------------------
isLinkPost :: Metadata -> Bool
isLinkPost meta = case lookupString "external-url" meta of
    Just _  -> True
    Nothing -> False

postUrlField :: Context String
postUrlField = field "postUrl" $ \item -> do
    meta <- getMetadata (itemIdentifier item)
    case lookupString "external-url" meta of
        Just url -> return url
        Nothing  -> getRoute (itemIdentifier item) >>= maybe (fail "No route") return

displayDateField :: Context String
displayDateField = field "displayDate" $ \item -> do
    meta <- getMetadata (itemIdentifier item)
    case lookupString "display-date" meta of
        Just d  -> return d
        Nothing -> do
            time <- getItemUTC defaultTimeLocale (itemIdentifier item)
            return $ formatTime defaultTimeLocale "%B %e, %Y" time

main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route idRoute
        compile compressCssCompiler

    match "fonts/*" $ do
        route idRoute
        compile copyFileCompiler

    match "posts/*/*" $ do
        route $ setExtension "html"
        compile $ do
            meta <- getMetadata =<< getUnderlying
            if isLinkPost meta
                then makeItem ("" :: String)
                else
                    pandocCompilerWith readerOptions writerOptions
                        >>= loadAndApplyTemplate "templates/post.html" postCtx
                        >>= loadAndApplyTemplate "templates/default.html" postCtx
                        >>= relativizeUrls

    match "about.html" $ do
        route $ setExtension "html"
        compile $
            pandocCompiler
                >>= loadAndApplyTemplate "templates/default.html" postCtx
                >>= relativizeUrls

    match "index.html" $ do
        route idRoute
        compile $ do
            musicPosts <- recentFirst =<< loadAll "posts/music/*"
            researchPosts <- recentFirst =<< loadAll "posts/research/*"

            let indexCtx =
                    listField "musicPosts" postCtx (return musicPosts)
                        `mappend` listField "researchPosts" postCtx (return researchPosts)
                        `mappend` defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler

--------------------------------------------------------------------------------
readerOptions :: ReaderOptions
readerOptions =
    defaultHakyllReaderOptions
        { readerExtensions =
            enableExtension Ext_raw_html (readerExtensions defaultHakyllReaderOptions)
        }

writerOptions :: WriterOptions
writerOptions = defaultHakyllWriterOptions

postCtx :: Context String
postCtx =
    postUrlField
        `mappend` displayDateField
        `mappend` dateField "date" "%Y-%m-%d"   -- still required for sorting
        `mappend` metadataField
        `mappend` defaultContext
