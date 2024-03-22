To build out the workshops we can plan using the following action items:

- Breakdown the content into 3 distinct sessions.
- Session #1:

  - Write instructions for the first session to setup flutter and have `flutter doctor` run with no issues.
  - Build out a branch that has the correct file structure but with an empty project.
  - Show a demo of what the final project will look like and how it will function.
  - Start build the bottom navigation for 2 pages.
  - Start building the `Add Trip` form.
  - Add validators to the form.
  - Complete the session by having a notifier pass state between pages.

- Session #2:

  - Build out a branch that has the bare minimum setup to build out the trip form.
  - Save trips in local storage.
  - Start building the `My Trips` page.
  - Final version of this session would load added trips to the `My Trips` page.

- Session #3:

  - Add API integration for weather data.
  - Clean up UI -- [Implmented but not 'code-along']
  - display weather features accordingly.

  - Navigate back to `MyTrips` after adding a trip.
  - Delete trip functionality.
  - Have user feedback (i.e toast message)

- For each session create a git brach
- Each git branch will have comments to fill in the logic focused in the respective session
- Ensure that some of the logic that is implemented is interactive so that the audience can get a feel of dart and flutter

# Presentation Order:

## Session #1

1. Introduction to Workshop workflow [Lucy]
2. Introduction to work-along app [Or-el]
3. Review Flutter installation [Or-el]
4. Build bottom navigation tabs, [Lucy]
5. Build `Add Trip` form. [Or-el]
6. Q&A [Lucy + Or-el]

## Session #2

1. Review of what we built last session [Or-el]
2. Introduction to what we will build in this session [Lucy]
3. Add `Hive` and `model data` for persisted state + error handling [Lucy]
4. Creating `Provider` + `Notifier` to use with pages [Lucy]
5. Build out the `MyTrips` page and connect to `Hive` [Or-el]
6. Q&A [Lucy + Or-el]

## Session #3

1. Add API integration for weather data. [Lucy]
2. Set up `TripCard` for session 3 bolierplate code. [Lucy]
3. Display weather features accordingly. [Lucy]
4. Navigate back to `MyTrips` after adding a trip. [Or-el]
5. Delete trip functionality. [Or-el]
6. Have user feedback (i.e toast message) [Or-el]

# Workshop Invite

Hey Builders,

Please join us for a 3-session, in person workshop where we'll dive deeper into mobile development with Flutter. Some things you'll learn include:

- Creating layouts
- Populating forms
- Persisting state locally
- Integrating remote API calls
- Error handling
- and more.

This workshop will focus mainly on Flutter development for iOS/Android platforms, and will involve interactive code-along sessions in Dart. All capabilities and skill levels are welcome!

In preparation for the first session, we recommend that you install Flutter via the official documentation below:
https://docs.flutter.dev/get-started/install

If you run into any issues during installation, bring your questions to the workshop.

Hope to see you there!
Lucy & Or-el
