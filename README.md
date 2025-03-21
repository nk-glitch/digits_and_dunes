Digits and Dunes
Mobile App Architectural Pattern: MVVM (Model-View-ViewModel)

Overview
Digits and Dunes is a mobile educational adventure game designed to make learning math an engaging and immersive experience. Built using the MVVM (Model-View-ViewModel) architectural pattern, the app ensures a clear separation of concerns between the UI, business logic, and data management, enabling better maintainability, testability, and scalability.
1. Adventure Worlds
Players embark on a thrilling journey across four unique, desert-themed worlds, each presenting progressively challenging levels and distinct visual themes. These worlds are:
Desert Mirage – A sun-scorched landscape filled with illusions and challenges.
Oasis Havens – Lush, hidden sanctuaries offering moments of respite and learning.
Pyramid Peaks – Towering pyramids with complex puzzles and secrets.
Ancient Ruins – Mysterious, crumbling ruins where the hardest levels reside.
World Progression and Level Unlocking
Each world is divided into multiple levels, which players must complete in sequence.
Players unlock new levels by successfully completing the prior ones. Advancement is dependent on performance, ensuring mastery before progressing.
Each world concludes with a unique final challenge that must be overcome to access the next world.

2. Level Design and Gameplay Mechanics
Each level contains a series of math problems tailored to that world’s difficulty level. Problems vary in type, including multiplication, addition, subtraction, and word problems. A sample problem is:
Example:
 Question: 22 x 12 = ?
 Options:
120


240


264 (correct answer)


244



Each level contains five math problems, and the score is calculated based on accuracy.


Stars are rewarded (0 to 3) based on the player’s performance in each level.



3. Rewards and Progression
Treasure Collection
Players earn special trophies by completing all levels in a world with 3 stars.
Trophies are displayed in the Treasure Room, a customizable gallery showcasing player achievements.
Each trophy is uniquely themed based on the world it represents.
Friends and Social Interaction
Players can add friends through a dedicated menu using usernames or invite codes.
Friend activity is visible, allowing players to track friends’ progress across the level maps in real time.
Players can compete with their friends for higher scores and trophies.
Leaderboard System
The app includes two separate leaderboard tabs:
Global Leaderboard: Displays the top players worldwide, encouraging competitive gameplay.
Friends Leaderboard: Highlights rankings among friends, fostering friendly rivalry.
Leaderboards are dynamic and update in real-time, reflecting new scores immediately upon level completion.

4. Adaptive Difficulty and Game Progression
Each level increases in complexity as players progress through a world, incorporating larger numbers, multi-step problems, and time constraints.
The app dynamically adjusts question difficulty using an internal algorithm based on player performance, ensuring the experience remains challenging yet accessible.
Final levels in each world are boss-style challenges that test everything the player has learned.

Firebase Integration
User Data Storage
Firebase is the backbone of Digits and Dunes’ backend, enabling secure and efficient storage and retrieval of user data. Tracked data includes:
Player Progress: Current world, unlocked levels, stars earned, and trophy status.
Leaderboard Scores: Individual scores for each level and cumulative scores.
Friends’ Progress: Real-time visibility into where friends are on the level map, including their current level and score.
Leaderboard Functionality
Firebase stores and updates scores for global and friend-specific leaderboards.
Efficient querying ensures quick access to top scores, allowing leaderboards to load rapidly and accurately.
Real-Time Updates
Leveraging Firebase’s real-time database, all progress updates (level completion, new trophies, leaderboard changes) are instantly synchronized across all devices.
This ensures players always see the most current rankings and friend statuses without delay.

