var express = require('express');
var router = express.Router();

/*
 * GET all users
 */
router.get('/', function(req, res) {
  var db = req.db;
  var collection = db.get('user');
  collection.find({}, {}, function(e, docs) {
    res.json(docs);
  });
});

/*
 * GET a user
 */
router.get('/:id', function(req, res) {
  var db = req.db;
  var userId = req.params.id;
  var collection = db.get('user');
  collection.findOne({
    "_id": userId
  }, {}, function(err, doc) {
    if (doc == null) {
      res.status(404) // HTTP status 404: NotFound
      res.send('Not found');
    } else {
      res.json(doc);
    }
  });
});

/*
 * Update a user
 */
router.put('/:id', function(req, res) {
  var db = req.db;
  var userId = req.params.id;
  var collection = db.get('user');
  collection.update({
    "_id": userId
  }, req.body, function(err, result) {
    res.send(
      (err === null) ? {
        msg: ''
      } : {
        msg: err
      }
    );
  });
});

/*
 * Create new user
 */
router.post('/', function(req, res) {
  var db = req.db;
  var collection = db.get('user');
  collection.insert(req.body, function(err, result) {
    res.send(
      (err === null) ? {
        msg: ''
      } : {
        msg: err
      }
    );
  });
});

/*
 * DELETE user
 */
router.delete('/:id', function(req, res) {
  var db = req.db;
  var collection = db.get('user');
  var userToDelete = req.params.id;
  collection.remove({
    '_id': userToDelete
  }, function(err) {
    res.send((err === null) ? {
      msg: ''
    } : {
      msg: 'error: ' + err
    });
  });
});

module.exports = router;
