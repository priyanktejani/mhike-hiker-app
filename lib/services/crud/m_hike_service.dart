import 'dart:async';
import 'package:mhike/services/crud/crud_exceptions.dart';
import 'package:mhike/services/crud/model/comment.dart';
import 'package:mhike/services/crud/model/hike.dart';
import 'package:mhike/services/crud/model/model_constants.dart';
import 'package:mhike/services/crud/model/observation.dart';
import 'package:mhike/services/crud/model/picture.dart';
import 'package:mhike/services/crud/model/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MHikeService {
  Database? _db;

  List<Hike> _hikes = [];
  List<Observation> _observations = [];
  List<Picture> _pictures = [];
  List<Comment> _comments = [];

  static final MHikeService _shared = MHikeService._sharedInstance();

  // StreamController require to manipulate data (ex. add, remove)
  late final StreamController<List<Hike>> _hikesStreamController;
  late final StreamController<List<Observation>> _observationsStreamController;
  late final StreamController<List<Picture>> _picturesStreamController;
  late final StreamController<List<Comment>> _commentsStreamController;

  MHikeService._sharedInstance() {
    _hikesStreamController = StreamController<List<Hike>>.broadcast(
      onListen: () {
        _hikesStreamController.sink.add(_hikes);
      },
    );

    _observationsStreamController =
        StreamController<List<Observation>>.broadcast(
      onListen: () {
        _observationsStreamController.sink.add(_observations);
      },
    );

    _picturesStreamController = StreamController<List<Picture>>.broadcast(
      onListen: () {
        _picturesStreamController.sink.add(_pictures);
      },
    );

    _commentsStreamController = StreamController<List<Comment>>.broadcast(
      onListen: () {
        _commentsStreamController.sink.add(_comments);
      },
    );
  }

  factory MHikeService() => _shared;

  // getter for stream of data
  Stream<List<Hike>> get allHikes => _hikesStreamController.stream;
  Stream<List<Observation>> get allObservations =>
      _observationsStreamController.stream;
  Stream<List<Picture>> get allPictures => _picturesStreamController.stream;
  Stream<List<Comment>> get allComments => _commentsStreamController.stream;

  // cache functions
  Future<void> _cacheHikes() async {
    final allHikes = await getAllHikes();
    _hikes = allHikes.toList();
    _hikesStreamController.add(_hikes);
  }

  Future<void> _cacheObservations() async {
    final allAllObservation = await getAllObservation();
    _observations = allAllObservation.toList();
    _observationsStreamController.add(_observations);
  }

  Future<void> _cachePictures() async {
    final allPictures = await getAllPictures();
    _pictures = allPictures.toList();
    _picturesStreamController.add(_pictures);
  }

  Future<void> _cacheComments() async {
    final allComments = await getAllComments();
    _comments = allComments.toList();
    _commentsStreamController.add(_comments);
  }

  // open database
  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      // get directory
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      // create the user table
      await db.execute(createUserTable);
      // create hike table
      await db.execute(createHikeTable);
      // create Observation table
      await db.execute(createObservationTable);
      // create Picture table
      await db.execute(createPictureTable);
      // create Comment table
      await db.execute(createCommentTable);
      // caching
      await _cacheHikes();
      await _cacheObservations();
      await _cachePictures();
      await _cacheComments();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  // ensure db is open
  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // empty
    }
  }

  // close databse
  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  // check id database is open
  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  // CRUD for user table
  // create
  Future<User> createUser({required User user}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // query to get user from email
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [user.email.toLowerCase()],
    );

    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }

    final userId = await db.insert(userTable, user.toJson());
    return getUser(userId);
  }

  // get user
  Future<User> getUser([
    int? id,
    String? email,
  ]) async {
    // either id or emai required
    if (email == null && id == null) {
      throw EitherIdOrEmailRequired();
    }

    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final List<Map<String, Object?>> results;

    // if user email
    if (email != null) {
      results = await db.query(
        userTable,
        limit: 1,
        where: 'email = ?',
        whereArgs: [email.toLowerCase()],
      );
      // if user id
    } else {
      results = await db.query(
        userTable,
        limit: 1,
        where: 'id = ?',
        whereArgs: [id],
      );
    }

    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return User.fromRow(results.first);
    }
  }

  // get user or create user
  Future<User> getOrCreateUser({
    required User user,
  }) async {
    try {
      // get user
      return await getUser(null, user.email);
    } on CouldNotFindUser {
      // create user
      return await createUser(user: user);
    } catch (e) {
      rethrow;
    }
  }

  // remove
  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    // if delete count 1, than user is deleted
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  // for hike table
  // create
  Future<Hike> addHike({
    required User user,
    required Hike newHike,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // make sure user exists in the database with the correct email
    final dbUser = await getUser(null, user.email);
    if (dbUser != user) {
      throw CouldNotFindUser();
    }

    // insert the hike
    int hikeId = await db.insert(hikeTable, newHike.toJson());
    // get hike
    final hike = await getHike(id: hikeId);

    // add hike to stream
    // _hikes.add(hike);
    // _hikesStreamController.add(_hikes);

    return hike;
  }

  // get hike
  Future<Hike> getHike({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // query hikes with id
    final hikes = await db.query(
      hikeTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (hikes.isEmpty) {
      throw CouldNotFindHike();
    } else {
      final hike = Hike.fromJson(hikes.first);

      _hikes.removeWhere((hike) => hike.id == id);
      _hikes.add(hike);
      _hikesStreamController.add(_hikes);

      return hike;
    }
  }

  // get all hikes
  Future<Iterable<Hike>> getAllHikes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final hikes = await db.query(hikeTable);

    return hikes.map((hikeRow) => Hike.fromJson(hikeRow));
  }

  // update hike
  Future<Hike> updateHike({
    required Hike hike,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // make sure hike exists
    await getHike(id: hike.id!);

    // update DB
    final updatesCount = await db.update(
      hikeTable,
      hike.toJson(),
      where: 'id = ?',
      whereArgs: [hike.id],
    );
    // if update count not 0
    if (updatesCount == 0) {
      throw CouldNotUpdateHike();
    } else {
      final updatedHike = await getHike(id: hike.id!);

      // update hike in stream (remove and add updated)
      _hikes.removeWhere((hike) => hike.id == updatedHike.id);
      _hikes.add(updatedHike);
      _hikesStreamController.add(_hikes);
      return updatedHike;
    }
  }

  // remove all hike
  Future<int> deleteAllHikes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(hikeTable);

    // reset stream
    _hikes = [];
    _hikesStreamController.add(_hikes);

    return numberOfDeletions;
  }

  // remove hike
  Future<void> deleteHike({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      hikeTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteHike();
    } else {
      // remove hike from stream
      _hikes.removeWhere((hike) => hike.id == id);
      _hikesStreamController.add(_hikes);
    }
  }

  // search hike
  Future<Hike> searchHike({
    required String title,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final hikes = await db.query(
      hikeTable,
      limit: 1,
      where: 'title LIKE ?',
      whereArgs: ['%$title%'],
    );

    if (hikes.isEmpty) {
      throw CouldNotFindHike();
    } else {
      final hike = Hike.fromJson(hikes.first);

      return hike;
    }
  }

  // CRUD for observation table
  // create
  Future<Observation> addObservation({
    required Hike hike,
    required Observation newObservation,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // make sure hike exists in the database with the correct id
    final dbHike = await getHike(id: hike.id!);
    if (dbHike != hike) {
      throw CouldNotFindHike();
    }

    // add the observation
    int observationId =
        await db.insert(observationTable, newObservation.toJson());
    final observation = await getObservation(id: observationId);

    // add observations to the stream
    // _observations.add(observation);
    // _observationsStreamController.add(_observations);

    return observation;
  }

  // get observation
  Future<Observation> getObservation({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final observations = await db.query(
      observationTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (observations.isEmpty) {
      throw CouldNotFindObservation();
    } else {
      final observation = Observation.fromJson(observations.first);

      _observations.removeWhere((observation) => observation.id == id);
      _observations.add(observation);
      _observationsStreamController.add(_observations);
      return observation;
    }
  }

  //  get alll observations
  Future<Iterable<Observation>> getAllObservation() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final observations = await db.query(observationTable);

    return observations
        .map((observationRow) => Observation.fromJson(observationRow));
  }

  //  remove observation
  Future<void> deleteObservation({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      observationTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteObservation();
    } else {
      _observations.removeWhere((observations) => observations.id == id);
      _observationsStreamController.add(_observations);
    }
  }

  // update observation
  Future<Observation> updateObservation({
    required Observation observation,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // make sure hike exists
    await getObservation(id: observation.id!);

    // update DB
    final updatesCount = await db.update(
      observationTable,
      observation.toJson(),
      where: 'id = ?',
      whereArgs: [observation.id],
    );
    // if update count not 0
    if (updatesCount == 0) {
      throw CouldNotUpdateHike();
    } else {
      final updatedObservation = await getObservation(id: observation.id!);

      // update observation in stream (remove and add updated)
      _observations.removeWhere(
          (observation) => observation.id == updatedObservation.id);
      _observations.add(updatedObservation);
      _observationsStreamController.add(_observations);
      return updatedObservation;
    }
  }

  // remove all observation
  Future<int> deleteAllObservation() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(observationTable);

    // reset stream
    _observations = [];
    _observationsStreamController.add(_observations);

    return numberOfDeletions;
  }

  // CRUDfor comment table
  // create
  Future<Comment> addComment({
    required Hike hike,
    required Comment newComment,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // make sure comment exists in the database with the correct id
    final dbHike = await getHike(id: hike.id!);
    if (dbHike != hike) {
      throw CouldNotFindComment();
    }

    // add comment to database
    int commentId = await db.insert(commentTable, newComment.toJson());
    final comment = await getComment(id: commentId);

    //  add comment to stream
    // _comments.add(comment);
    // _commentsStreamController.add(_comments);

    return comment;
  }

  // get comment
  Future<Comment> getComment({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final comments = await db.query(
      commentTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (comments.isEmpty) {
      throw CouldNotFindComment();
    } else {
      final comment = Comment.fromRow(comments.first);

      _comments.removeWhere((comment) => comment.id == id);
      _comments.add(comment);
      _commentsStreamController.add(_comments);
      return comment;
    }
  }

  // get all comments
  Future<Iterable<Comment>> getAllComments() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final comment = await db.query(commentTable);

    return comment.map((commentRow) => Comment.fromRow(commentRow));
  }

  // remove comment
  Future<void> deleteComment({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final deletedCount = await db.delete(
      commentTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deletedCount == 0) {
      throw CouldNotDeleteObservation();
    } else {
      // remove from stream
      _comments.removeWhere((comment) => comment.id == id);
      _commentsStreamController.add(_comments);
    }
  }

  // remove all comments
  Future<int> deleteAllComments() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(commentTable);

    // reset stream
    _comments = [];
    _commentsStreamController.add(_comments);

    return numberOfDeletions;
  }

  // CRUDfor picture table
  // create
  Future<Picture> addPicture({
    required Hike hike,
    required Picture newPicture,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // make sure picture exists in the database with the correct id
    final dbHike = await getHike(id: hike.id!);
    if (dbHike != hike) {
      throw CouldNotFindHike();
    }

    // add picture to database
    int pictureId = await db.insert(pictureTable, newPicture.toJson());
    final picture = await getPicture(id: pictureId);

    //  add picture to stream
    // _pictures.add(picture);
    // _picturesStreamController.add(_pictures);

    return picture;
  }

  // get picture
  Future<Picture> getPicture({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final pictures = await db.query(
      pictureTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (pictures.isEmpty) {
      throw CouldNotFindPicture();
    } else {
      final picture = Picture.fromJson(pictures.first);

      _pictures.removeWhere((picture) => picture.id == id);
      _pictures.add(picture);
      _picturesStreamController.add(_pictures);
      return picture;
    }
  }

  // get all pictures
  Future<Iterable<Picture>> getAllPictures() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final picture = await db.query(pictureTable);

    return picture.map((pictureRow) => Picture.fromJson(pictureRow));
  }

  // remove picture
  Future<void> deletePicture({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final deletedCount = await db.delete(
      pictureTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deletedCount == 0) {
      throw CouldNotDeleteObservation();
    } else {
      // remove from stream
      _pictures.removeWhere((picture) => picture.id == id);
      _picturesStreamController.add(_pictures);
    }
  }

  // remove all pictures
  Future<int> deleteAllPictures() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(pictureTable);

    // reset stream
    _pictures = [];
    _picturesStreamController.add(_pictures);

    return numberOfDeletions;
  }
}
