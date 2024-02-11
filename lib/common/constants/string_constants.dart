class DateTimeFormats {
  static const isoFormatUTC = "yyyy-MM-ddTHH:mm:ss";
  static const isoFormatLocal = "yyyy-MM-ddTHH:mm:ss";
  static const yyyy = "yyyy";
  static const ddMMMMyyyy = "dd MMMM yyyy";
  static const ddMMMyyyy = "dd MMM yyyy";
  static const hhmmaa = "hh:mm aa";
  static const ddMMM = "dd MMM";
}

class Strings {
  /// Message Text
  static const success = "Success";
  static const warning = "Warning";
  static const info = "Info";
  static const error = "Error";

  // Google Account Scope
  static const profileScope = "profile";

  // Shared Prefs Keys
  static const themeKey = "theme";

  // General
  static const asc = "Asc";
  static const desc = "Desc";
  static const ascL = "Ascending";
  static const descL = "Descending";

  static const updatedOn = "Updated On";
  static const createdOn = "Created On";
  static const createdOn2 = "Created on";
  static const lastUpdatedOn = "Last updated on";

  static const sortBy = "Sort By";
  static const order = "Order";
  static const done = "Done";
  static const welcome = "Welcome";
  static const user = "User";

  static const somethingWentWrong = "Something went wrong";
  static const accountDeleteLoginAgain = "Account deleted successfully. Please sign in again.";
  static const signedOut = "Signed out";

  static const signInWithGoogle = "Sign in with Google";
  static const signInAsGuest = "Sign as a guest";
  static const or = "OR";
  static const taskAddedSuccessfully = "Task added successfully";
  static const taskUpdatedSuccessfully = "Task updated successfully";
  static const taskDeletedSuccessfully = "Task deleted successfully";

  static const updateYourTask = "Update your task";
  static const addATask = "Add a task";
  static const enterSomething = "Enter something";
  static const hintText = "Write away....";
  static const update = "Update";
  static const add = "Add";
  static const settings = "Settings";
  static const theme = "Theme";
  static const darkTheme = "Dark";
  static const lightTheme = "Light";
  static const deviceTheme = "System";
  static const account = "Account";
  static const appInfo = "App Info";
  static const guestUser = "Guest User ";
  static const signOut = "Sign Out";
  static const deleteAccount = "Delete Account";
  static const areYouSureWantToDelete = "Are you sure you want to delete your account?";
  static const permanentAction = "This action is permanent and means all your tasks and completed items will be erased forever.";
  static const preferences = "Preferences";
  static const filter = "Filter";
  static const sort = "Sort";
  static const addNewTask = "Add new task";
  static const noCompletedTodos = "No completed todos found";
  static const noPendingTodos = "No pending todos found";
  static const markAsIncomplete = "Mark as incomplete";
  static const markAsComplete = "Mark as complete";
  static const editTask = "Edit task";
  static const deleteTask = "Delete task";

  static List<String> randomNoTodosMessages = [
    "Time to blast off on your next adventure! What will you tackle first?",
    "What's your next big target?",
    "Fresh start! Your to-do list awaits your next adventure.",
    "What will you blast off to achieve next?",
  ];
}

class AppInfo {
  static const appName = "Flowdo";
  static const packageName = "com.rejie.flowdo";
  static const appVersion = 'v1.0.0 Alpha 3';
  static const builtWithFlutter = "Built with Flutter";
  static const madeBy = "Jerin Jacob (@webrror)";
}