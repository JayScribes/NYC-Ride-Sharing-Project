Skills Used:
  Ggplot, cowplot,
Exploratory data analysis, cleaning, and visualization


accidents_day$weekday[accidents_day$weekday ==1] <- "Sunday"
accidents_day$weekday[accidents_day$weekday ==2] <- "Monday"
accidents_day$weekday[accidents_day$weekday ==3] <- "Tuesday"
accidents_day$weekday[accidents_day$weekday ==4] <- "Wednesday"
accidents_day$weekday[accidents_day$weekday ==5] <- "Thursday"
accidents_day$weekday[accidents_day$weekday ==6] <- "Friday"
accidents_day$weekday[accidents_day$weekday ==7] <- "Saturday"

ggplot(accidents_day, aes(x = weekday, y = num_accidents,)) +
  geom_bar(stat = "identity") +
  scale_x_discrete(limits=c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")) +
  labs(x="Day of the Week", y= "Number of Accidents",title="Number of Alcohol-Related Motor Vehicle Accidents in New York City") +
  theme_classic()


ggplot(accident_hour, aes(x=hour_of_accident,y=num_accidents))+
  geom_bar(stat="identity")+
  labs(x="Hour of the Day", y= "Number of Accidents", title="Alcohol-Related Motor Vehicle Accidents in New York City as a FUnction of Time of Day") +
  scale_x_discrete(limits=c(0:23))+
  theme_classic() + theme(plot.title=element_text(size=10))

ggplot(uber_rides_frisatsun_byhour, aes(x=uber_hour,y=uber_count)) +
  geom_bar(stat="identity")+
  labs(x="Hour of the Day",y="Uber Rides",title="Frequency of Uber Rides on Fridays, Saturdays, and Sundays by Hour")+
  scale_x_discrete(limits=c(0:23)) +theme_classic()


## Accidents & Weather Variables
rain_accident <-ggplot(accidents_weather, aes(x=rain_mm,y=count_accident))+
  geom_point() +geom_smooth(method=lm,se=FALSE) +
  labs(x="Rain (mm)",y="Number of Accidents",title="Number of Accidents as a Function of Rain") +
  theme_classic()+theme(plot.title=element_text(size=10))+theme(axis.title=element_text(size=8))

snow_accident <-ggplot(accidents_weather, aes(x=snow_mm,y=count_accident))+
  geom_point() +geom_smooth(method=lm,se=FALSE) +
  labs(x="Snow (mm)",y="Number of Accidents",title="Number of Accidents as a Function of Snow")+
  theme_classic()+theme(plot.title=element_text(size=10))+theme(axis.title=element_text(size=8))

maxtemp_accident <- ggplot(accidents_weather, aes(x=max_temp,y=count_accident))+
  geom_point() +geom_smooth(method=lm,se=FALSE) +
  labs(x="Daily Max Temp. (C)",y="Number of Accidents",title="Number of Accidents as a Function of Daily Max Temperature")+
  theme_classic()+theme(plot.title=element_text(size=10))+theme(axis.title=element_text(size=8))

mintemp_accident <- ggplot(accidents_weather, aes(x=min_temp,y=count_accident))+
  geom_point() +geom_smooth(method=lm,se=FALSE)  +
  labs(x="Daily Min Temp. (C)",y="Number of Accidents",title="Number of Accidents as a Function of Daily Min Temperature")+
  theme_classic()+theme(plot.title=element_text(size=10))+theme(axis.title=element_text(size=8))

accidents_weather_fig <- plot_grid(snow_accident,rain_accident,maxtemp_accident,mintemp_accident,
                                   labels=c("A","B","C","D"), label_size= 12)


accident_weather_regression <- lm(count_accident ~snow_mm, data=accidents_weather)
summary(accident_weather_regression)

##Daily Earnings & Weather Variables
rain_earnings <- ggplot(uber_weather, aes(x=rain_mm,y=total_amount))+
  geom_point() +geom_smooth(method=lm,se=FALSE) +
  labs(x="Rain(mm)",y="Total Daily Ride Earnings",title="Total Daily  Ride Earnings as a Function of Rain",
       caption="*single data point towards end of x-axis deleted;outlier")+
  theme_classic()+theme(plot.title=element_text(size=8))+theme(axis.title=element_text(size=6))


snow_earnings <- ggplot(uber_weather, aes(x=snow_mm,y=total_amount))+
  geom_point() +geom_smooth(method=lm,se=FALSE)+
  labs(x="Snow (mm)",y="Total Daily Ride Earnings",title="Total Daily Ride Earnings as a Function of Snow")+
  theme_classic()+theme(plot.title=element_text(size=8))+theme(axis.title=element_text(size=6))

maxtemp_earnings <- ggplot(uber_weather, aes(x=max_temp,y=total_amount))+
  geom_point() +geom_smooth(method=lm,se=FALSE)+
  labs(x="Max Temp (C)",y="Total Daily Ride Earnings",title="Total Daily Ride Earnings as a Function of Max Temperature")+
  theme_classic()+theme(plot.title=element_text(size=8))+theme(axis.title=element_text(size=6))

mintemp_earnings <- ggplot(uber_weather, aes(x=min_temp,y=total_amount))+
  geom_point() +geom_smooth(method=lm,se=FALSE)+
  labs(x="Min Temp (C)",y="Total Daily Ride Earnings",title="Total Daily Ride Earnings as a Function of Min Temperature")+
  theme_classic()+theme(plot.title=element_text(size=8))+theme(axis.title=element_text(size=6))

earnings_weather_fig <- plot_grid(snow_earnings,rain_earnings,maxtemp_earnings,mintemp_earnings,
                                  labels=c("A","B","C","D"), label_size= 12)

earnings_weather_regression1 <- lm(total_amount ~snow_mm, data=uber_weather)
summary(earnings_weather_regression1)

earnings_weather_regression2 <- lm(total_amount ~rain_mm, data=uber_weather)
summary(earnings_weather_regression2)

earnings_weather_multiple_regression <- lm(total_amount ~ snow_mm + rain_mm, data=uber_weather)
summary(earnings_weather_multiple_regression)

## Passenger Count & Weather Variables

rain_passengers <- ggplot(uber_weather, aes(x=rain_mm,y=total_passenger))+
  geom_point()+geom_smooth(method=lm,se=FALSE) +
  labs(x="Rain (mm)",y="Total Daily Passengers",title="Total Daily Passengers as a Function of Rain")+
  theme_classic()+theme(plot.title=element_text(size=10))+theme(axis.title=element_text(size=8))

snow_passengers <- ggplot(uber_weather, aes(x=snow_mm,y=total_passenger))+
  geom_point()+geom_smooth(method=lm,se=FALSE) +
  labs(x="Snow (mm)",y="Total Daily Passengers",title="Total Daily Passengers as a Function of Snow")+
  theme_classic()+theme(plot.title=element_text(size=10))+theme(axis.title=element_text(size=8))

maxtemp_passengers <- ggplot(uber_weather, aes(x=max_temp,y=total_passenger))+
  geom_point() +geom_smooth(method=lm,se=FALSE)+
  labs(x="Max Temp (C)",y="Total Daily Ride Passengers",title="Total Daily Passengers as a Function of Max Temperature")+
  theme_classic()+theme(plot.title=element_text(size=10))+theme(axis.title=element_text(size=8))

mintemp_passengers <- ggplot(uber_weather, aes(x=min_temp,y=total_amount))+
  geom_point() +geom_smooth(method=lm,se=FALSE)+
  labs(x="Min Temp (C)",y="Total Daily Ride Earnings",title="Total Daily Passengers as a Function of Min Temperature")+
  theme_classic()+theme(plot.title=element_text(size=10))+theme(axis.title=element_text(size=8))

earnings_weather_fig <- plot_grid(snow_passengers,rain_passengers,maxtemp_passengers,mintemp_passengers,
                                  labels=c("A","B","C","D"), label_size= 12)
## Total Rides & Weather Variables
rain_rides <- ggplot(uber_weather, aes(x=rain_mm,y=total_count))+
  geom_point()+geom_smooth(method=lm,se=FALSE) +
  labs(x="Rain (mm)",y="Total Daily Rides",title="Total Daily Rides as a Function of Rain")+
  theme_classic()+theme(plot.title=element_text(size=10))+theme(axis.title=element_text(size=8))

snow_rides <- ggplot(uber_weather, aes(x=snow_mm,y=total_count))+
  geom_point()+geom_smooth(method=lm,se=FALSE) +
  labs(x="Snow (mm)",y="Total Daily Rides",title="Total Daily Rides as a Function of Snow")+
  theme_classic()+theme(plot.title=element_text(size=10))+theme(axis.title=element_text(size=8))

maxtemp_rides <- ggplot(uber_weather, aes(x=max_temp,y=total_count))+
  geom_point() +geom_smooth(method=lm,se=FALSE)+
  labs(x="Max Temp (C)",y="Total Daily Rides",title="Total Daily Rides as a Function of Max Temperature")+
  theme_classic()+theme(plot.title=element_text(size=10))+theme(axis.title=element_text(size=8))

mintemp_rides <- ggplot(uber_weather, aes(x=min_temp,y=total_count))+
  geom_point() +geom_smooth(method=lm,se=FALSE)+
  labs(x="Min Temp (C)",y="Total Daily Rides",title="Total Daily Rides as a Function of Min Temperature",cex.title=0.1)+
  theme_classic() +theme(plot.title=element_text(size=10))+theme(axis.title=element_text(size=8))

earnings_weather_fig <- plot_grid(snow_rides,rain_rides,maxtemp_rides,mintemp_rides,
                                  labels=c("A","B","C","D"), label_size= 12)+theme(plot.title=element_text(size=10))+theme(axis.title=element_text(size=8))

earnings_weather_regression1 <- lm(total_count ~snow_mm, data=uber_weather)
summary(earnings_weather_regression1)

earnings_weather_regression2 <- lm(total_count ~rain_mm, data=uber_weather)
summary(earnings_weather_regression2)

