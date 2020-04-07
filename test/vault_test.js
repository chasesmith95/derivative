var assert = require('assert');
describe('Vault', function() {
    describe('Getting and Setting Variables', function() {
  describe('Construction', function() {
    it('should return -1 when the value is not present', function() {
      assert.equal([1, 2, 3].indexOf(4), -1);
    });
  });

  describe('Updating variables', function() {
    it('should return -1 when the value is not present', function() {
      assert.equal([1, 2, 3].indexOf(4), -1);
    });
  });

  describe('Duration Sanity Check', function() {
    it('should return -1 when the value is not present', function() {
      assert.equal([1, 2, 3].indexOf(4), -1);
    });
  });
    });

  describe('State transitions', function() {
    describe('Activation', function() {
      it('should return -1 when the value is not present', function() {
        assert.equal([1, 2, 3].indexOf(4), -1);
      });
    });

    describe('Issuance', function() {
      it('Should change', function() {
        assert.equal([1, 2, 3].indexOf(4), -1);
      });
      it("assets should be able to be traded after issuance", function() {
        assert.equal([1, 2, 3].indexOf(4), -1);
      });
    });

    describe('Settlement', function() {
      it('should return -1 when the value is not present', function() {
        assert.equal([1, 2, 3].indexOf(4), -1);
      });
    });
  });

  describe('Payments', function() {
        describe('Fees', function() {
      describe('Vault Construction Fees', function() {
        it('Activation', function() {
          assert.equal([1, 2, 3].indexOf(4), -1);
        });
      });

      describe('Collecting Creation Fees', function() {
        it('Activation', function() {
          assert.equal([1, 2, 3].indexOf(4), -1);
        });
      });

      describe('Derivative Issuance Fees', function() {
        it('Activation', function() {
          assert.equal([1, 2, 3].indexOf(4), -1);
        });
      });
        });
     describe('Collateral', function() {
          it('Activation', function() {
                assert.equal([1, 2, 3].indexOf(4), -1);
        });
    });
  });


  describe('External Contract Calls', function() {
    it('should return -1 when the value is not present', function() {
      assert.equal([1, 2, 3].indexOf(4), -1);
    });
  });
});
