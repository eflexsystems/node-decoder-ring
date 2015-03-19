// Generated by CoffeeScript 1.6.1
(function() {
  var FieldEncoder;

  FieldEncoder = (function() {

    function FieldEncoder() {}

    FieldEncoder.prototype.findSpecBufferSize = function(spec) {
      var f, sizes, _i, _len, _ref;
      sizes = [];
      _ref = spec.fields;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        f = _ref[_i];
        sizes.push(this.findFieldLength(f));
      }
      return sizes.reduce(function(a, b) {
        return Math.max(a, b);
      });
    };

    FieldEncoder.prototype.findFieldLength = function(field) {
      var length;
      length = (function() {
        switch (field.type) {
          case 'int8':
          case 'uint8':
          case 'bit':
            return 1;
          case 'int16':
          case 'uint16':
            return 2;
          case 'uint32':
          case 'int32':
          case 'float':
            return 4;
          case 'double':
            return 8;
          case 'ascii':
          case 'utf8':
          case 'buffer':
            return field.length;
        }
      })();
      return field.start + length;
    };

    FieldEncoder.prototype.encodeFieldBE = function(buffer, obj, fieldSpec) {
      var val;
      val = obj[fieldSpec.name];
      if ((val == null) && (fieldSpec["default"] != null)) {
        val = fieldSpec["default"];
      }
      if (val != null) {
        switch (fieldSpec.type) {
          case 'int8':
            buffer.writeInt8(val, fieldSpec.start);
            break;
          case 'uint8':
            buffer.writeUInt8(val, fieldSpec.start);
            break;
          case 'int16':
            buffer.writeInt16BE(val, fieldSpec.start);
            break;
          case 'uint16':
            buffer.writeUInt16BE(val, fieldSpec.start);
            break;
          case 'float':
            buffer.writeFloatBE(val, fieldSpec.start);
            break;
          case 'double':
            buffer.writeDoubleBE(val, fieldSpec.start);
            break;
          case 'ascii':
            buffer.write(val, fieldSpec.start, fieldSpec.length, 'ascii');
            break;
          case 'utf8':
            buffer.write(val, fieldSpec.start, fieldSpec.length, 'utf8');
            break;
          case 'uint32':
            buffer.writeUInt32BE(val, fieldSpec.start);
            break;
          case 'int32':
            buffer.writeInt32BE(val, fieldSpec.start);
            break;
          case 'buffer':
            val.copy(buffer, fieldSpec.start, 0, fieldSpec.length);
            break;
          case 'bit':
            if (val === true) {
              buffer.writeUInt8(Math.pow(2, fieldSpec.position), fieldSpec.start);
            } else {
              buffer.writeUInt8(0, fieldSpec.start);
            }
        }
      }
      return buffer;
    };

    FieldEncoder.prototype.encodeFieldLE = function(buffer, obj, fieldSpec) {
      var val;
      val = obj[fieldSpec.name];
      if ((val == null) && (fieldSpec["default"] != null)) {
        val = fieldSpec["default"];
      }
      if (val != null) {
        switch (fieldSpec.type) {
          case 'int8':
            buffer.writeInt8(val, fieldSpec.start);
            break;
          case 'uint8':
            buffer.writeUInt8(val, fieldSpec.start);
            break;
          case 'int16':
            buffer.writeInt16LE(val, fieldSpec.start);
            break;
          case 'uint16':
            buffer.writeUInt16LE(val, fieldSpec.start);
            break;
          case 'float':
            buffer.writeFloatLE(val, fieldSpec.start);
            break;
          case 'double':
            buffer.writeDoubleLE(val, fieldSpec.start);
            break;
          case 'ascii':
            buffer.write(val, fieldSpec.start, fieldSpec.length, 'ascii');
            break;
          case 'utf8':
            buffer.write(val, fieldSpec.start, fieldSpec.length, 'utf8');
            break;
          case 'uint32':
            buffer.writeUInt32LE(val, fieldSpec.start);
            break;
          case 'int32':
            buffer.writeInt32LE(val, fieldSpec.start);
            break;
          case 'buffer':
            val.copy(buffer, fieldSpec.start, 0, fieldSpec.length);
            break;
          case 'bit':
            if (val === true) {
              buffer.writeUInt8(Math.pow(2, fieldSpec.position), fieldSpec.start);
            } else {
              buffer.writeUInt8(0, fieldSpec.start);
            }
        }
      }
      return buffer;
    };

    return FieldEncoder;

  })();

  module.exports = FieldEncoder;

}).call(this);