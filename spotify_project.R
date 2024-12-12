# Loading the packages and libraries.
library("rjson")
library(jsonlite)
library(lubridate)
library(gghighlight)
library(tidyverse)
library(knitr)
library(ggplot2)
library(ggdark)
library(plotly)

# Give the input file name to the function.
streamHistory <- fromJSON("Desktop/Spotify-Wrapped-R/data.json", flatten = TRUE)  %>% 
  bind_rows()

# Adding date and timing.
streamHistory_clean <- streamHistory %>% 
  rename(endTime = ts, artistName = master_metadata_album_artist_name, trackName = master_metadata_track_name)) %>% 
  mutate(
    endTime = ymd_hms(endTime), 
    date = as_date(endTime),
    seconds = as.numeric(ms_played) / 1000, 
    minutes = seconds / 60
  )

mySpotify <- streamHistory_clean


# Playback activity per week and hours.
streamingHours <- mySpotify %>%
  filter(date >= "2024-01-01") %>% 
  group_by(date = floor_date(date, "week")) %>% 
  summarize(hours = sum(minutes, na.rm = TRUE) / 60) %>% 
  arrange(date) %>% 
  ggplot(aes(x = date, y = hours)) +
  geom_col(aes(fill = hours)) +
  theme_minimal() +
  scale_fill_gradient(low = "#1db954", high = "#1db954") +
  labs(x = "Date", y = "Hours") +
  ggtitle("Playback Activity Per Week") 

# Playback activity per specific artist.
hoursArtist <- mySpotify %>% 
  group_by(artistName, date = floor_date(date, "month")) %>% 
  summarize(hours = sum(minutes, na.rm = TRUE), .groups = "drop") %>% 
  ggplot(aes(x = date, y = hours, group = artistName, color = artistName)) + 
  labs(x = "Date", y = "Hours") + 
  ggtitle("Playback Activity Per Artist") +
  geom_line() + theme_minimal() +
  hoursArtist


# Most listened artists.
minutesMostListened <- mySpotify %>% 
  filter(date >= "2024-01-01") %>% 
  group_by(artistName) %>% 
  summarize(minutesListened = sum(minutes)) %>% 
  filter(minutesListened >= 180) %>%
  ggplot(aes(x = reorder(artistName, minutesListened), y = minutesListened)) + 
  geom_col(aes(fill = minutesListened)) + theme_minimal() +
  scale_fill_gradient(low = "#1db954", high = "#1db954") + 
  labs(x= "Artist", y= "Minutes") + 
  ggtitle("Playback activity per artist") +
  theme(axis.text.x = element_text(angle = 90))
minutesMostListened + coord_flip()


# Playback activity by date and time of the day.
timeDay <- mySpotify %>% 
  filter(date >= "2024-01-01") %>% 
  group_by(date, hour = hour(endTime)) %>% 
  summarize(minutesListened = sum(minutes, na.rm = TRUE), .groups = "drop") %>% 
  ggplot(aes(x = hour, y = date, fill = minutesListened)) + 
  geom_tile() + theme_minimal() +
  labs(x = "Time of the day", y = "Date") + 
  ggtitle("When Has There Been More Playback Activity on My Spotify?", "Activity by Date and Time of Day") +
  scale_fill_gradient(low = "black", high = "#1db954")
timeDay


# Playback activity by time of the day.
hoursDay <- mySpotify %>% 
  filter(date >= "2014-01-01") %>% 
  group_by(date, hour = hour(endTime), weekday = wday(date, label = TRUE))%>% 
  summarize(minutesListened = sum(minutes))
hoursDay %>% 
  ggplot(aes(x = hour, y = minutesListened, group = date)) + 
  geom_col(fill = "#1db954") +  theme_minimal() +
  labs(x= "Time of the day", y= "Minutes") + 
  ggtitle("Activity from 0 to 24 hours")


# Playback activity by time of the day and weekday - Line Chart
weekDay <- hoursDay %>% 
  group_by(weekday, hour) %>% 
  summarize(minutes = sum(minutesListened)) %>% 
  ggplot(aes(x = hour, y = minutes, color = weekday)) + 
  geom_line() + theme_minimal() +
  labs(x= "Time of the day", y= "Minutes") + 
  ggtitle("Weekly activity from 0 to 24 hours") 
weekDay


# Playback activity by day time.
dayType <- hoursDay %>% 
  mutate(day_type = if_else(weekday %in% c("Sat", "Sun"), "weekend", "weekday")) %>% 
  group_by(day_type, hour) %>% 
  summarize(minutes = sum(minutesListened)) %>% 
  ggplot(aes(x = hour, y = minutes, color = day_type)) + 
  geom_line() + theme_minimal() +
  labs(x= "Time of the day", y= "Minutes") + 
  ggtitle("Weekday and weekend activity from 0 to 24 hours") 
dayType


# Number of songs I play per day : bar chart
'''songsByDay <- mySpotify %>% 
  filter(!is.na(msPlayed) & msPlayed >= 1000) %>%
  group_by(date) %>% 
  group_by(date = floor_date(date, "day")) %>%
  summarize(songs = n()) %>% 
  arrange(date) %>% 
  ggplot(aes(x = date, y = songs)) + 
  geom_col(aes(fill = songs)) + theme_minimal() +
  scale_fill_gradient(high = "#1db954", low = "#1db954") + 
  labs(x= "Date", y= "Number of Songs Played") + 
  ggtitle("Number of songs I play per day", "November 2021 to November 2022")
songsByDay'''


# Most listened songs.
minutesTMostListened <- mySpotify %>% 
  filter(date >= "2024-01-01") %>% 
  filter(!is.na(trackName)) %>% # Ensure trackName exists
  group_by(trackName) %>% 
  summarize(minutesListened = sum(minutes, na.rm = TRUE)) %>% 
  filter(minutesListened >= 180) %>%
  ggplot(aes(x = reorder(trackName, minutesListened), y = minutesListened)) + 
  geom_col(aes(fill = minutesListened)) + theme_minimal() +
  scale_fill_gradient(low = "#1db954", high = "#1db954") + 
  labs(x= "Song", y= "Minutes") + 
  ggtitle("Most listened songs") +
  theme(axis.text.x = element_text(angle = 90))
minutesTMostListened + coord_flip()
