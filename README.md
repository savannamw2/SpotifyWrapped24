## Overview

**Project Title**: Spotify Wrapped for 2024

**Project Description**: I used R, which is good to read data, to create my own spotify wrapped. I created different graphs to show my top artist, what artists I listened to the most, what times of I listened to music, etc. I had R create graphs that could easily read from my json file. 

**Project Goals**: I wanted to find the statistics from this year according to my Spotify Data. After seeing that many people thought this years data was scewed, I wanted to see if I got different results from the report Spotify produced. I was able to extract the data and put into a json file. I wanted to this json file to read and create statistics based on what it read. 

## Instructions for Build and Use

Steps to build and/or run the software:

1. Download R Studio
2. Download R
3. Request personal spotify data
4. Convert the .zip file into json format
5. Download and the run the necessary libraries in R Studio (avoids errors when running in R console)

Instructions for using the software:


1. Call the libraries first 
2. Initizialize the json file before accessing the data.
3. Review R documentation on creating different functions

## Development Environment 

To recreate the development environment, you need the following software and/or libraries with the specified versions:

1. Import library("rjson")
2. Import library(jsonlite)
3. Import library(lubridate)
4. Import library(gghighlight)
5. Import library(tidyverse)
6. Import library(knitr)
7. Import library(ggplot2)
8. Import library(ggdark)
9. Importlibrary(plotly)
10. R Studio
11. R Language

## Useful Websites to Learn More

I found these websites useful in developing this software:

* [Medium](https://hibrantapia.medium.com/how-to-make-your-own-spotify-wrapped-with-r-be6ca7277d38)
* [R Documentation](https://www.rdocumentation.org/)
* [W3Schoosls](https://www.w3schools.com/r/r_intro.asp)

## Future Work

The following items I plan to fix, improve, and/or add to this project in the future:

* [ ] I plan to fix the artists that come up as NA bc it scews results. 
* [ ] I want to include a dark theme
* [ ] Improve the GUI so that it is easily readable. 
