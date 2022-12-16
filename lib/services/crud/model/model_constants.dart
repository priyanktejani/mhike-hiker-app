// model constant

// database name
const dbName = 'mhike.db';

// common constant
const idColumn = 'id';
const dateTimeColumn = 'date_time';
const hikeIdColumn = 'hike_id';
const userEmailColumn = 'user_email';


// user table constant
const userTable = 'user';
const emailColumn = 'email';
const usernameColumn = 'username';
const fullNameColumn = 'full_name';

const createUserTable = '''CREATE TABLE IF NOT EXISTS $userTable (
	$idColumn	INTEGER NOT NULL UNIQUE,
	$emailColumn	TEXT NOT NULL UNIQUE,
	$usernameColumn	TEXT NOT NULL UNIQUE,
  $fullNameColumn	TEXT NOT NULL UNIQUE,
	PRIMARY KEY($idColumn AUTOINCREMENT)
);''';


// hike table constant
const hikeTable = 'hike';
const coverImageColumn = 'cover_image';
const titleColumn = 'title';
const difficultyLevelColumn = 'difficulty_level';
const parkingAvailabilityColumn = 'parking_availablity';
const lengthColumn = 'length';
const estimatedTimeColumn = 'estimated_time';
const locationColumn = 'location';
const descriptionColumn = 'description';
const popularityIndexColumn = 'popularity_index';

const createHikeTable = '''CREATE TABLE IF NOT EXISTS $hikeTable (
	$idColumn INTEGER NOT NULL UNIQUE,
	$userEmailColumn TEXT NOT NULL,
  $coverImageColumn TEXT,
	$titleColumn TEXT NOT NULL,
  $dateTimeColumn TEXT NOT NULL,
  $difficultyLevelColumn TEXT NOT NULL,
  $parkingAvailabilityColumn BOOLEN NOT NULL DEFAULT 0,
  $lengthColumn	DOUBLE NOT NULL DEFAULT 0.0,
  $locationColumn TEXT NOT NULL,
  $estimatedTimeColumn TEXT NOT NULL DEFAULT 0,
  $descriptionColumn TEXT,
  $popularityIndexColumn INTEGER DEFAULT 0,
  FOREIGN KEY($userEmailColumn) REFERENCES "user"($emailColumn),
	PRIMARY KEY($idColumn AUTOINCREMENT)
);''';


// observation table constant
const observationTable = 'observation';
const observationTitleColumn = 'observation_title';
const observationCategoryColumn = 'observation_category';
const observationDetailColumn = 'observation_detail';

const createObservationTable = '''CREATE TABLE IF NOT EXISTS $observationTable (
	$idColumn	INTEGER NOT NULL UNIQUE,
  $hikeIdColumn INTEGER NOT NULL,
	$observationTitleColumn TEXT NOT NULL,
	$observationCategoryColumn TEXT NOT NULL,
  $observationDetailColumn TEXT NOT NULL,
  $dateTimeColumn TEXT NOT NULL,
	PRIMARY KEY($idColumn AUTOINCREMENT)
);''';


// picture table constant
const pictureTable = 'picture';
const hikePictureColumn = 'hike_picture';

const createPictureTable = '''CREATE TABLE IF NOT EXISTS $pictureTable (
	$idColumn	INTEGER NOT NULL UNIQUE,
  $hikeIdColumn INTEGER NOT NULL,
	$hikePictureColumn TEXT NOT NULL,
  $dateTimeColumn TEXT NOT NULL,
	PRIMARY KEY($idColumn AUTOINCREMENT)
);''';


// comment table constant
const commentTable = 'comment';
const hikeRatingColumn = 'hike_rating';
const hikeCommentColumn = 'hike_comment';

const createCommentTable = '''CREATE TABLE IF NOT EXISTS $commentTable (
	$idColumn	INTEGER NOT NULL UNIQUE,
  $hikeIdColumn INTEGER NOT NULL,
	$userEmailColumn TEXT NOT NULL,
  $hikeRatingColumn DOUBLE NOT NULL,
  $hikeCommentColumn TEXT NOT NULL,
  $dateTimeColumn TEXT NOT NULL,
	PRIMARY KEY($idColumn AUTOINCREMENT)
);''';
