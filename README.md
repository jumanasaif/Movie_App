# 🎬 Flutter Movie App — TMDb API  
A modern Flutter movie streaming application 
The app uses **The Movie Database (TMDb) API** and **Riverpod** for state management.

---

## 📱 Features

### ⭐ Core Functionality
- Users can browse both **Movies** and **TV Shows** through well-organized categories, including:

  - Popular Movies / TV Shows

  - Top Rated Movies / TV Shows

  - Now Playing Movies / On Air TV Shows

- View detailed pages:
  - Title, Poster, Backdrop
  - Overview / Description
  - Genres &Runtime
  - Rating & Release Date
  - Budget & Revenue
  - Cast & Actors
  - Similar Movie / TV  &  Videos
  
- Search & Filter for any movie or TV show
- Infinite Scroll + Smooth Pagination
- Polished UI with modern design

### ❤️ User Features
- **Favorites System** (Movies + TV)
- **Add Rating** for movies
- Favorites are stored **per user** using **SharedPreferences** 
- Login persists favorites, movies, and TV series
- All favorites and ratings **remain saved after logout & login**

### 👤 Authentication
- Login / Signup system  
- Secure user session
- Logout resets providers safely

---

## 🧰 **Tech Stack**

| Category | Technology |
|---------|------------|
| Framework | Flutter (Latest Stable) |
| Language | Dart |
| State Management | **Riverpod** |
| API | The Movie Database (TMDb) |
| Local Storage | SharedPreferences |
| Navigation | GoRouter |
| Architecture | MVVM + Repository Pattern |

---

## 🧩 **Project Structure**

lib/ ├── core/ │ ├── theme/ | ├── data/ │ ├── models/ │ ├── services/ │ └── repositories/ │ ├── presentation/ │ ├── screens/ │ ├── widgets/ │ ├── providers/ ├── routes/ └── main.dart
---

## 🔌 **API Integration (TMDb)**

This application integrates with **The Movie Database (TMDb)** using multiple REST API endpoints.  
The app supports Movies, TV Shows, Persons, Trending content, Search, Filtering, and Media Details.

---

### 🎬 **Movie Endpoints**
Used to display different movie categories inside the app:

- `/movie/popular` — Popular Movies  
- `/movie/top_rated` — Top Rated Movies  
- `/movie/now_playing` — Now Playing Movies  
- `/trending/movie/day` — Daily Trending Movies  
- `/search/movie` — Search for Movies  
- `/discover/movie` — Filtering, sorting, and genre-based browsing  
- `/movie/{id}` — Movie Details  
- `/movie/{id}/credits` — Movie Cast  
- `/movie/{id}/videos` — Trailers & Videos  

---

### 📺 **TV Show Endpoints**
Used to display TV categories inside the app:

- `/tv/popular` — Popular TV Shows  
- `/tv/top_rated` — Top Rated TV Shows  
- `/tv/on_the_air` — Currently Airing TV Shows  
- `/trending/tv/day` — Daily Trending TV Shows  
- `/search/tv` — TV Show Search  
- `/discover/tv` — Filter by genres, year, or sorting  
- `/tv/{id}` — TV Details  
- `/tv/{id}/credits` — TV Cast  
- `/tv/{id}/videos` — Trailers & Clips  

---

### 🧩 **Genres Endpoints**
Used for filtering, category creation, and UI data:

- `/genre/movie/list` — Movie Genres  
- `/genre/tv/list` — TV Genres  

---

### 👤  **People / Cast / Crew Endpoints**
The app also interacts with TMDb *Person* API to retrieve information about:

- Actors  
- Directors  
- Writers  
- Producers  
- Crew Members  

Endpoints used:

- `/person/{id}` — Person Details  
- `/person/popular` — Popular People (Actors & Cast)
- `/search/person` — Person Search   
These endpoints allow the app to show detailed cast pages and link movies & TV shows to their respective actors and crew members.

---

Each request is handled through:
- A repository layer  
- Error handling  
- Pagination support  

---

## 📦 **State Management — Why Riverpod?**

This project uses **Riverpod** because:

1. It is modern and type-safe  
2. Supports dependency injection  
3. Works well with async APIs  
4. AutoDispose cleans memory automatically  
5. Much easier to test and scale compared to Provider  

Example:

```dart
final favoritesProvider = StateNotifierProvider<FavoriteNotifier, List<Movie>>((ref) {
  return FavoriteNotifier();
});

