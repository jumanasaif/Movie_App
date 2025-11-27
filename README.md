# 🎬 Flutter Movie App — TMDb API  
A modern Flutter movie streaming application 
The app uses **The Movie Database (TMDb) API** and **Riverpod** for state management.

---

## 📱 **Features**

### ⭐ Core Functionality

Users can browse Movies, TV Shows, and People using rich, well-structured categories:

#### 🎬 Movies & TV Shows Categories
- **Popular Movies / TV Shows**
- **Top Rated Movies / TV Shows**
- **Now Playing Movies / On Air TV Shows**
- **Genre-based Filtering & Sorting**
- **Search for any Movie or TV Show**
- **Infinite Scroll + Smooth Pagination**

---

### 🧑‍🎬 People / Cast / Crew
The app includes full support for TMDb People API, allowing users to browse:

- Popular Actors  
- Directors  
- Writers  
- Producers  
- Crew Members  

Each person has a full detail page that includes:

- Profile Image  
- Name & Department (Acting, Directing, etc.)  
- Popularity Score  
- Movies and TV Shows they participated in  
- Full biography (if available)

---

### 📄 Detailed Media Pages (Movie & TV Details)

Each Movie / TV Show includes:

- Poster & Backdrop Images  
- Title  
- Overview / Description  
- Genres  
- Runtime (Movies) / Episode Runtime (TV)  
- Release Date / First Air Date  
- Rating  
- Budget & Revenue (Movies)  
- Cast & Actors  
- Videos (Trailers, Clips)  
- Similar Movies / Similar TV Shows  

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

<img width="367" height="356" alt="image" src="https://github.com/user-attachments/assets/4a1694f4-2205-4af7-b54b-cde434cb14f9" />

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

