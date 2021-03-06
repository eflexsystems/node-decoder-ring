expect = require("chai").expect
subject = require('../src/FieldEncoder')

describe "FieldEncoder unit test", ->
  beforeEach ->
    {_, _, @bufferBESpec, @bufferLESpec} = require("./Fixtures")

  describe "responds to", ->
    it "encodeFieldBE", ->
      expect(subject).to.respondTo("encodeFieldBE")

    it "findSpecBufferSize", ->
      expect(subject).to.respondTo("findSpecBufferSize")

    it "findFieldLength", ->
      expect(subject).to.respondTo("findFieldLength")

    it "encodeFieldLE", ->
      expect(subject).to.respondTo("encodeFieldLE")

  describe "#encodeFieldBE", ->
    it "defaults the value according to the fieldSpec when property is undefined", ->
      expectedBuffer = Buffer.alloc(2)
      expectedBuffer.writeInt8(-11, 1)

      outBuffer = Buffer.alloc(2)

      obj = {}
      fieldSpec = {name: "field1", start: 1, type: 'int8', default: -11}

      result = subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "does not encode if the object's property is undefined and there isn't a default", ->
      expectedBuffer = Buffer.alloc(2)
      outBuffer = Buffer.alloc(2)

      obj = {field1: undefined}
      fieldSpec = {name: "field1", start: 1, type: 'int8'}

      result = subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "does not encode if the object's property is null and there isn't a default", ->
      expectedBuffer = Buffer.alloc(2)
      outBuffer = Buffer.alloc(2)

      obj = {field1: null}
      fieldSpec = {name: "field1", start: 1, type: 'int8'}

      result = subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an int8 field", ->
      expectedBuffer = Buffer.alloc(2)
      expectedBuffer.writeInt8(-11, 1)

      outBuffer = Buffer.alloc(2)

      obj = {field1: -11}
      fieldSpec = {name: "field1", start: 1, type: 'int8'}

      result = subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an uint8 field", ->
      expectedBuffer = Buffer.alloc(2)
      expectedBuffer.writeUInt8(11, 1)

      outBuffer = Buffer.alloc(2)

      obj = {field2: 11}
      fieldSpec = {name: "field2", start: 1, type: 'uint8'}

      result = subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an int16 field", ->
      expectedBuffer = Buffer.alloc(3)
      expectedBuffer.writeInt16BE(-305, 1)

      outBuffer = Buffer.alloc(3)

      obj = {field3: -305}
      fieldSpec = {name: "field3", start: 1, type: 'int16'}

      result = subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an uint16 field", ->
      expectedBuffer = Buffer.alloc(3)
      expectedBuffer.writeUInt16BE(305, 1)

      outBuffer = Buffer.alloc(3)

      obj = {field4: 305}
      fieldSpec = {name: "field4", start: 1, type: 'uint16'}

      result = subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an float field", ->
      expectedBuffer = Buffer.alloc(10)
      expectedBuffer.writeFloatBE(305.11, 1)

      outBuffer = Buffer.alloc(10)

      obj = {field5: 305.11}
      fieldSpec = {name: "field5", start: 1, type: 'float'}

      result = subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an double field", ->
      expectedBuffer = Buffer.alloc(10)
      expectedBuffer.writeDoubleBE(30005.11, 1)

      outBuffer = Buffer.alloc(10)

      obj = {field6: 30005.11}
      fieldSpec = {name: "field6", start: 1, type: 'double'}

      result = subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an ascii field", ->
      expectedBuffer = Buffer.alloc(15)
      expectedBuffer.write("ascii text", 1, 10, 'ascii')

      outBuffer = Buffer.alloc(15)

      obj = {field7: "ascii text"}
      fieldSpec = {name: "field7", start: 1, type: 'ascii', length: 10}

      result = subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an ascii field with padding", ->
      expectedBuffer = Buffer.alloc(15)
      expectedBuffer.write("ascii text     ", 0, 15, 'ascii')

      outBuffer = Buffer.alloc(15)

      obj = {field7: "ascii text"}
      fieldSpec = {name: "field7", start: 0, type: 'ascii', length: 15}

      result = subject.encodeFieldBE(outBuffer, obj, fieldSpec, ' ')
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an utf8 field", ->
      expectedBuffer = Buffer.alloc(15)
      expectedBuffer.write("utf8 text", 1, 9, 'utf8')

      outBuffer = Buffer.alloc(15)

      obj = {field8: "utf8 text"}
      fieldSpec = {name: "field8", start: 1, type: 'utf8', length: 9}

      result = subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes a uint32 field", ->
      expectedBuffer = Buffer.alloc(9)
      expectedBuffer.writeUInt32BE(103423, 1)

      outBuffer = Buffer.alloc(9)

      obj = {field9: 103423}
      fieldSpec = {name: "field9", start: 1, type: 'uint32'}

      result = subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes a int32 field", ->
      expectedBuffer = Buffer.alloc(9)
      expectedBuffer.writeInt32BE(-103423, 1)

      outBuffer = Buffer.alloc(9)

      obj = {field10: -103423}
      fieldSpec = {name: "field10", start: 1, type: 'int32'}

      result = subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes a bit field", ->
      expectedBuffer = Buffer.alloc(2)
      expectedBuffer.writeInt8(4, 1)

      outBuffer = Buffer.alloc(2)

      obj = {field11: true}
      fieldSpec = {name: "field11", start: 1, type: 'bit', position: 2}

      result = subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes a buffer field", ->
      expectedBuffer = Buffer.from("testing")

      outBuffer = Buffer.alloc(7)

      obj = {field8: expectedBuffer}
      fieldSpec = {name: "field8", start: 0, type: 'buffer', length: 7}

      result = subject.encodeFieldBE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

  describe "#encodeFieldLE", ->
    it "will use the default default value according to the fieldSpec when property is undefined", ->
      expectedBuffer = Buffer.alloc(2)
      expectedBuffer.writeInt8(-11, 1)

      outBuffer = Buffer.alloc(2)

      obj = {}
      fieldSpec = {name: "field1", start: 1, type: 'int8', default: -11}

      result = subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "does not encode if the object's property is undefined and there isn't a default", ->
      expectedBuffer = Buffer.alloc(2)

      outBuffer = Buffer.alloc(2)

      obj = {field1: undefined}
      fieldSpec = {name: "field1", start: 1, type: 'int8'}

      result = subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "does not encode if the object's property is null and there isn't a default", ->
      expectedBuffer = Buffer.alloc(2)
      outBuffer = Buffer.alloc(2)

      obj = {field1: null}
      fieldSpec = {name: "field1", start: 1, type: 'int8'}

      result = subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an int8 field", ->
      expectedBuffer = Buffer.alloc(2)
      expectedBuffer.writeInt8(-11, 1)

      outBuffer = Buffer.alloc(2)

      obj = {field1: -11}
      fieldSpec = {name: "field1", start: 1, type: 'int8'}

      result = subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an uint8 field", ->
      expectedBuffer = Buffer.alloc(2)
      expectedBuffer.writeUInt8(11, 1)

      outBuffer = Buffer.alloc(2)

      obj = {field2: 11}
      fieldSpec = {name: "field2", start: 1, type: 'uint8'}

      result = subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an int16 field", ->
      expectedBuffer = Buffer.alloc(3)
      expectedBuffer.writeInt16LE(-305, 1)

      outBuffer = Buffer.alloc(3)

      obj = {field3: -305}
      fieldSpec = {name: "field3", start: 1, type: 'int16'}

      result = subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an uint16 field", ->
      expectedBuffer = Buffer.alloc(3)
      expectedBuffer.writeUInt16LE(305, 1)

      outBuffer = Buffer.alloc(3)

      obj = {field4: 305}
      fieldSpec = {name: "field4", start: 1, type: 'uint16'}

      result = subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an float field", ->
      expectedBuffer = Buffer.alloc(10)
      expectedBuffer.writeFloatLE(305.11, 1)

      outBuffer = Buffer.alloc(10)

      obj = {field5: 305.11}
      fieldSpec = {name: "field5", start: 1, type: 'float'}

      result = subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an double field", ->
      expectedBuffer = Buffer.alloc(10)
      expectedBuffer.writeDoubleLE(30005.11, 1)

      outBuffer = Buffer.alloc(10)

      obj = {field6: 30005.11}
      fieldSpec = {name: "field6", start: 1, type: 'double'}

      result = subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an ascii field", ->
      expectedBuffer = Buffer.alloc(15)
      expectedBuffer.write("ascii text", 1, 10, 'ascii')

      outBuffer = Buffer.alloc(15)

      obj = {field7: "ascii text"}
      fieldSpec = {name: "field7", start: 1, type: 'ascii', length: 10}

      result = subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an ascii field with padding", ->
      expectedBuffer = Buffer.alloc(15)
      expectedBuffer.write("ascii text     ", 0, 15, 'ascii')

      outBuffer = Buffer.alloc(15)

      obj = {field7: "ascii text"}
      fieldSpec = {name: "field7", start: 0, type: 'ascii', length: 15}

      result = subject.encodeFieldLE(outBuffer, obj, fieldSpec, ' ')
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes an utf8 field", ->
      expectedBuffer = Buffer.alloc(15)
      expectedBuffer.write("utf8 text", 1, 9, 'utf8')

      outBuffer = Buffer.alloc(15)

      obj = {field8: "utf8 text"}
      fieldSpec = {name: "field8", start: 1, type: 'utf8', length: 9}

      result = subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes a uint32 field", ->
      expectedBuffer = Buffer.alloc(9)
      expectedBuffer.writeUInt32LE(103423, 1)

      outBuffer = Buffer.alloc(9)

      obj = {field9: 103423}
      fieldSpec = {name: "field9", start: 1, type: 'uint32'}

      result = subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes a int32 field", ->
      expectedBuffer = Buffer.alloc(9)
      expectedBuffer.writeInt32LE(-103423, 1)

      outBuffer = Buffer.alloc(9)

      obj = {field10: -103423}
      fieldSpec = {name: "field10", start: 1, type: 'int32'}

      result = subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes a bit field", ->
      expectedBuffer = Buffer.alloc(2)
      expectedBuffer.writeInt8(4, 1)

      outBuffer = Buffer.alloc(2)

      obj = {field11: true}
      fieldSpec = {name: "field11", start: 1, type: 'bit', position: 2}

      result = subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)

    it "encodes a buffer field", ->
      expectedBuffer = Buffer.from("testing")

      outBuffer = Buffer.alloc(7)

      obj = {field8: expectedBuffer}
      fieldSpec = {name: "field8", start: 0, type: 'buffer', length: 7}

      result = subject.encodeFieldLE(outBuffer, obj, fieldSpec)
      expect(result).to.deep.equal(expectedBuffer)


  describe "#findFieldLength", ->
    it "works for int8's", ->
      field = {name: "field1", start: 2,  type: 'int8'  }

      result = subject.findFieldLength(field)
      expect(result).to.equal(3)

    it "works for uint8's", ->
      field = {name: "field1", start: 2,  type: 'uint8'  }

      result = subject.findFieldLength(field)
      expect(result).to.equal(3)

    it "works for int16's ", ->
      field = {name: "field1", start: 2,  type: 'uint16'  }

      result = subject.findFieldLength(field)
      expect(result).to.equal(4)

    it "works for float's", ->
      field = {name: "field1", start: 2,  type: 'float'  }

      result = subject.findFieldLength(field)
      expect(result).to.equal(6)

    it "works for double's", ->
      field = {name: "field1", start: 2,  type: 'double'  }

      result = subject.findFieldLength(field)
      expect(result).to.equal(10)

    it "works for ascii's", ->
      field = {name: "field1", start: 2,  type: 'ascii', length: 55  }

      result = subject.findFieldLength(field)
      expect(result).to.equal(57)

    it "works for utf8's", ->
      field = {name: "field1", start: 2,  type: 'utf8', length: 59  }

      result = subject.findFieldLength(field)
      expect(result).to.equal(61)

    it "works for uint32's", ->
      field = {name: "field1", start: 2,  type: 'uint32' }

      result = subject.findFieldLength(field)
      expect(result).to.equal(6)

    it "works for int32's", ->
      field = {name: "field1", start: 2,  type: 'int32' }

      result = subject.findFieldLength(field)
      expect(result).to.equal(6)

    it "works for bit's", ->
      field = {name: "field1", start: 2,  type: 'bit', position: 3 }

      result = subject.findFieldLength(field)
      expect(result).to.equal(3)

    it "works for buffers", ->
      field = {name: "field1", start: 2,  type: 'buffer', length: 3 }

      result = subject.findFieldLength(field)
      expect(result).to.equal(5)

  describe "#findSpecBufferSize", ->
    it "finds the max size of a buffer", ->
      result = subject.findSpecBufferSize(@bufferLESpec)
      expect(result).to.equal(50)


