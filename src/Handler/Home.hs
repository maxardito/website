{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes.yesodroutes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
--
data MusicItem = MusicItem {musicName :: Text, musicLink :: Maybe Text} 
data ResearchItem = ResearchItem {researchName :: Text, researchLink :: Maybe Text} 
data VideoItem = VideoItem {videoName :: Text, videoLink :: Maybe Text} 
data InstrumentItem = InstrumentItem {instrumentName :: Text, instrumentLink :: Maybe Text} 
data ArticleItem = ArticleItem {articleName :: Text, articleLink :: Maybe Text} 
data WorkshopItem = WorkshopItem {workshopName :: Text, workshopLink :: Maybe Text} 

getImageR :: [Text] -> Handler TypedContent
getImageR imagePaths = do
    let imagePath = "static" </> intercalate "/" (map unpack imagePaths)
    sendFile "image/jpeg" imagePath  -- Change the content type and file format as needed


getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do
        let musicItems = [MusicItem {musicName = "Improvisations", musicLink = Nothing}, 
                          MusicItem {musicName = "Sinthomatic Music I. - V.", musicLink = Nothing}, 
                          MusicItem {musicName = "Learning What To Do With Your Sinthome Instead of Enjoing It", musicLink = Just "https://dreamingbeyond.ai/en/f/pluriverse/future-present-visions-new-vibrations/sinthomatic-music-digital-intimacy"}]

        let videoItems = [VideoItem "Advertisement Reel" Nothing]
                          -- VideoItem "MAX ARDITO - LIVE AT ROULETTE" Nothing, 
                          -- VideoItem "MAX ARDITO - LIVE AT ISSUE PROJECT ROOM" Nothing,
                          -- VideoItem "MAX ARDITO - LIVE AT PIONEER WORKS" Nothing, 
                          -- VideoItem "MAX ARDITO - LIVE AT ELSEWHERE" Nothing, 
                          -- VideoItem "MAX ARDITO - LIVE AT NATIONAL SAWDUST" Nothing, 
                          -- VideoItem "MAX ARDITO - LIVE AT THE STONE" Nothing]

        let researchItems = [ResearchItem "A Typomorphological Approach To The Timbre Transfer" Nothing, 
                             ResearchItem "Modeling the RCA Mark II Tone Generator and Oscillator Units" (Just "https://www.cirmmt.org/en/funding/ice-recipient-reports/ardito2023-24-1"),
                             ResearchItem "Evaluating and Preparing Object-Contact Models For User Interaction" (Just "http://www.music.mcgill.ca/~gary/courses/projects/618_2022/ArditoReport.pdf"),
                             ResearchItem "Reconstructing The Vibraphone Version of ...explosante fixe... by Pierre Boulez" Nothing]

        let instrumentItems = [InstrumentItem "Messed Up" (Just "https://shop.cutelab.nyc/eurorack/messed-up/"), 
                               InstrumentItem "Missed Opportunities" (Just "https://shop.cutelab.nyc/eurorack/missed-opportunities/")]

        let articleItems = [ArticleItem "Using Latent Timbral Space to Communicate with The Dead" (Just "https://archive.wetink.org/archive-06/using-latent-timbral-space-to-communicate-with-the-dead"), 
                            ArticleItem "On The Fermentation of Digital Media" (Just "https://unthinking.photography")]
                             
        let workshopItems = [WorkshopItem "Signal Representation Theory for Artists [Rhizome / ONX]" (Just "https://rhizome.org/events/signal-representation-theory-workshop/"), 
                             WorkshopItem "Music and The Internet [CuteLab]" Nothing,
                             WorkshopItem "Contemporary Music Creation and Critique [IRCAM]" Nothing]
        aDomId <- newIdent
        setTitle "MAX ARDITO"
        $(widgetFile "homepage")
