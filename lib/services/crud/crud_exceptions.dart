// CRUD exceptions


// database exceptions
class DatabaseAlreadyOpenException implements Exception {}
class UnableToGetDocumentsDirectory implements Exception {}
class DatabaseIsNotOpen implements Exception {}
class CouldNotDeleteUser implements Exception {}

// user exception
class UserAlreadyExists implements Exception {}
class CouldNotFindUser implements Exception {}

// hike exception
class CouldNotDeleteHike implements Exception {}
class CouldNotFindHike implements Exception {}
class CouldNotUpdateHike implements Exception {}

// observation exception
class CouldNotDeleteObservation implements Exception {}
class CouldNotFindObservation implements Exception {}
class CouldNotUpdateObservation implements Exception {}

// picture exception
class CouldNotDeletePicture implements Exception {}
class CouldNotFindPicture implements Exception {}
class CouldNotUpdatePicture implements Exception {}

// delete exception
class CouldNotDeleteComment implements Exception {}
class CouldNotFindComment implements Exception {}
class CouldNotUpdateComment implements Exception {}


class EitherIdOrEmailRequired implements Exception {}
