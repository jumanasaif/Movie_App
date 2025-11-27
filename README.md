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
  - Genres
  - Rating & Release Date
  - Cast & Actors
- Search for any movie or TV show
- Infinite Scroll + Smooth Pagination
- Polished UI with modern design

### ❤️ User Features
- **Favorites System** (Movies + TV)
- **Add Rating** for movies
- Favorites are stored **per user**
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
| Local Storage | SharedPreferences / Hive (for favorites & user data) |
| Navigation | GoRouter |
| Architecture | MVVM + Repository Pattern |

---

## 🧩 **Project Structure**

