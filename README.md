
# WeatherApp

## Project Overview
WeatherApp is a weather forecasting application that allows users to search for cities and get real-time weather data including temperature, humidity, wind speed, air quality, and more. The app also provides a 7-day weather forecast and allows users to save their favorite cities.

### Configuration
1. In the `WeatherService` class, replace the placeholder for the API key with your own from WeatherAPI:
   ```swift
   private let apiKey = "YOUR_API_KEY"
   ```

2. Run the project in Xcode:
   - Open `WeatherApp.xcworkspace` in Xcode.
   - Select a target device (simulator or real device).
   - Press `Cmd + R` to build and run the app.

## Features Implemented
- **City Search:** Allows users to search for cities and view real-time weather data.
- **Weather Display:** Displays current temperature, wind speed, humidity, pressure, and visibility.
- **7-day Forecast:** Provides weather forecast for the next 7 days.
- **Saved Cities:** Allows users to save and view the weather for their favorite cities.
- **Air Quality:** Displays air quality information for the searched city.

## Known Issues or Limitations
- **Weather Data Delays:** Sometimes, the weather data may not be updated in real-time due to API request limits or network issues.
- **City Search Inaccuracy:** The search may return unexpected results for some city names. It's important to ensure that city names are entered correctly.
- **API Limits:** The free tier of WeatherAPI allows a limited number of requests per day. Users may encounter errors if the request limit is exceeded.

## Third-Party Libraries Used
- **WeatherAPI:** This API is used to fetch the current weather and forecasts. It's chosen because of its simplicity and wide range of weather data.
  - [WeatherAPI Documentation](https://www.weatherapi.com/)

## Demo video
link: https://youtube.com/shorts/qA9lPHQwq6Y
