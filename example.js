const decoderRing = require("decoder-ring");

let bufferBE = Buffer.alloc(51);
bufferBE.writeInt8(-127, 0);
bufferBE.writeUInt8(254, 1);
bufferBE.writeInt16BE(5327, 2);
bufferBE.writeUInt16BE(5328, 4);
bufferBE.writeFloatBE(-15.33, 6);
bufferBE.writeDoubleBE(-1534.98, 10);
bufferBE.write("ascii", 18, 10,'ascii');
bufferBE.write("utf8 text", 28, 9, 'utf8');
bufferBE.writeUInt8(129, 37);
bufferBE.writeUInt32BE(79001, 38);
bufferBE.writeInt32BE(-79001, 42);
bufferBE.writeInt8(1, 46);

let testBuffer = new Buffer("test");
testBuffer.copy(bufferBE, 47, 0, 4);

let spec = {
  bigEndian: true,
  fields: [
    { name: "field1", start: 0,   type: 'int8'  },
    { name: "field2", start: 1,   type: 'uint8' },
    { name: "field3", start: 2,   type: 'int16' },
    { name: "field4", start: 4,   type: 'uint16'},
    { name: "field5", start: 6,   type: 'float' },
    { name: "field6", start: 10,  type: 'double'},
    { name: "field7", start: 18,  type: 'ascii', length: 10 },
    { name: "field8", start: 28,  type: 'utf8', length: 9  },
    { name: "field9", start: 37,  type: 'bit', position: 7 },
    { name: "field10", start: 37, type: 'bit', position: 6 },
    { name: "field11", start: 37, type: 'bit', position: 0 },
    { name: "field12", start: 38, type: 'uint32' },
    { name: "field13", start: 42, type: 'int32' },
    { name: "field14", start: 46, type: 'int8', default: 42 },
    { name: "field15", start: 47, type: 'buffer', length: 4 }
  ]
};

// Decode the buffer into a javascript object
let result = decoderRing.decode(spec, bufferBE);
console.log(result);

// Assign field14 to undefined to test default value on encoding
result.field14 = undefined;

// Encode the object to a buffer
let buffer = decoderRing.encode(spec, result);
console.log(buffer);

// Decode buffer to object and check field14 for default value
let resultWithDefaultValue = decoderRing.decode(spec, buffer);
console.log("Field14 default value: " + resultWithDefaultValue.field14);

