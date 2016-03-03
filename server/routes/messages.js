var express = require('express');
var router = express.Router();

/*
 * GET all messages
 */
router.get('/', function(req, res) {
  var db = req.db;
  var collection = db.messages;
  collection.find({}, {}, function(e, docs) {
    res.json(docs);
  });
});

/*
 * GET a message
 */
router.get('/:id', function(req, res) {
  var db = req.db;
  var messageId = req.params.id;
  var collection = db.messages;
  collection.findOne({
    "_id": messageId
  }, {}, function(err, doc) {
    if (doc == null) {
      res.status(404)
      res.send('Not found');
    } else {
      res.json(doc);
    }
  });
});

/*
 * Update a message
 */
router.put('/:id', function(req, res) {
  var db = req.db;
  var messageId = req.params.id;
  var collection = db.messages;
  collection.update({
    "_id": messageId
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
 * Create new message
 */
router.post('/', function(req, res) {
  var db = req.db;
  var collection = db.messages;
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
 * DELETE message
 */
router.delete('/:id', function(req, res) {
  var db = req.db;
  var collection = db.messages;
  var messageToDelete = req.params.id;
  collection.remove({
    '_id': messageToDelete
  }, function(err) {
    res.send(
      (err === null) ? {
        msg: ''
      } : {
        msg: err
      }
    );
  });
});

module.exports = router;
