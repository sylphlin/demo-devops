var assert = require('chai').assert;
var should = require('chai').should();
var expect = require('chai').expect();
var supertest = require('supertest');
var api = supertest('http://localhost:3000');

describe('01_Server_Status', function() {
  describe('Get server status', function() {
    it('Return status OK', function(done) {
      api.get('/')
      .end(function(err, res) {
        res.status.should.equal(200);
        done();
      });
    });
  });
});
