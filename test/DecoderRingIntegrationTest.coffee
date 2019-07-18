expect = require("chai").expect
subject = require("../src/DecoderRing")

describe "BinaryDecoderRing Integration Test", ->
  beforeEach ->
    {@bufferBE, @bufferLE, @bufferBESpec, @bufferLESpec} = require("./Fixtures")

  describe "#decode", ->
    it "decodes big endian specifications", ->
      result = subject.decode(@bufferBESpec, @bufferBE)

      expect(result.field1).to.equal(-127)
      expect(result.field2).to.equal(254)
      expect(result.field3).to.equal(5327)
      expect(result["field4"]).to.equal(5328)
      expect(result.field5).to.be.closeTo(-15.33, 0.01)
      expect(result.field6).to.be.closeTo(-1534.98, 0.01)
      expect(result.field7).to.equal("ascii text")
      expect(result.field8).to.equal("utf8 text")
      expect(result.field9).to.be.true
      expect(result.field10).to.be.false
      expect(result.field11).to.be.true
      expect(result.field12).to.equal(79001)
      expect(result.field13).to.equal(-79001)
      expect(result.field14).to.eql(Buffer.from("test"))

    it "decodes little endian specifications", ->
      result = subject.decode(@bufferLESpec, @bufferLE)

      expect(result.field1).to.equal(-127)
      expect(result.field2).to.equal(254)
      expect(result.field3).to.equal(5327)
      expect(result["field4"]).to.equal(5328)
      expect(result.field5).to.be.closeTo(-15.33, 0.01)
      expect(result.field6).to.be.closeTo(-1534.98, 0.01)
      expect(result.field7).to.equal("ascii text")
      expect(result.field8).to.equal("utf8 text")
      expect(result.field9).to.be.true
      expect(result.field10).to.be.false
      expect(result.field11).to.be.true
      expect(result.field12).to.equal(79002)
      expect(result.field13).to.equal(-79002)
      expect(result.field14).to.eql(Buffer.from("test"))

  describe "#encode", ->
    it "encodes big endian specifications", ->
      decoded = subject.decode(@bufferBESpec, @bufferBE)
      encoded = subject.encode(@bufferBESpec, decoded)
      expect(encoded).to.deep.equal(@bufferBE)

    it "encodes little endian specifications", ->
      decoded = subject.decode(@bufferLESpec, @bufferLE)
      encoded = subject.encode(@bufferLESpec, decoded)
      expect(encoded).to.deep.equal(@bufferLE)

    it "encodes bit fields by anding them together", ->
      spec = {
        bigEndian: false
        fields: [
          {name: "field1", start: 0,  type: 'bit', position: 0  }
          {name: "field2", start: 0,  type: 'bit', position: 1  }
          {name: "field3", start: 1,  type: 'bit', position: 2  }
          {name: "field4", start: 1,  type: 'bit', position: 3  }
        ]
      }

      obj = {
        field1: true
        field2: true
        field3: false
        field4: true
      }

      decoded = subject.encode(spec, obj)
      shouldBe = Buffer.alloc(2)
      shouldBe.writeInt8(3, 0)
      shouldBe.writeInt8(8, 1)
      expect(decoded).to.deep.equal(shouldBe)

    it "fills buffers with 0's", ->
      bufferSize50With0s = Buffer.alloc(50)

      spec = {
        bigEndian: false
        length: 50
        fields: [
          {name: "field1", start: 0,  type: 'bit', position: 0  }
        ]
      }

      result = subject.encode(spec, {})

      expect(result).to.deep.equal(bufferSize50With0s)

    it "doesn't calculate the size if a length field is in the spec", ->
      spec =
        length: 2
        fields: [
          { name: "field1", start: 0, type: 'int8' }
        ]

      result = subject.encode(spec, field1: 11)

      expect(result).to.have.length(2)

