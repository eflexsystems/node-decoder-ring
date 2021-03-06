padEnd = require('lodash.padend')

findFieldLength = (field) ->
  length = switch field.type
    when 'int8', 'uint8', 'bit'     then 1
    when 'int16', 'uint16'          then 2
    when 'uint32', 'int32', 'float' then 4
    when 'double'                   then 8
    when 'ascii', 'utf8', 'buffer'  then field.length

  return field.start + length

findSpecBufferSize = (spec) ->
  sizes = []

  for f in spec.fields
    sizes.push(findFieldLength(f))

  sizes.reduce((a, b) -> Math.max(a, b))

encodeFieldBE = (buffer, obj, fieldSpec, padding) ->
  val = obj[fieldSpec.name]

  if !val? and fieldSpec.default?
    val = fieldSpec.default

  if val?
    switch fieldSpec.type
      when 'int8'   then buffer.writeInt8(val, fieldSpec.start)
      when 'uint8'  then buffer.writeUInt8(val, fieldSpec.start)
      when 'int16'  then buffer.writeInt16BE(val, fieldSpec.start)
      when 'uint16' then buffer.writeUInt16BE(val, fieldSpec.start)
      when 'float'  then buffer.writeFloatBE(val, fieldSpec.start)
      when 'double' then buffer.writeDoubleBE(val, fieldSpec.start)
      when 'uint32' then buffer.writeUInt32BE(val, fieldSpec.start)
      when 'int32'  then buffer.writeInt32BE(val, fieldSpec.start)
      when 'buffer' then val.copy(buffer, fieldSpec.start, 0, fieldSpec.length)

      when 'ascii', 'utf8'
        if padding?
          val = padEnd(val, fieldSpec.length, padding)

        buffer.write(val, fieldSpec.start, fieldSpec.length, fieldSpec.type)

      when 'bit'
        if val is true # protection from type problems
          buffer.writeUInt8(2 ** fieldSpec.position, fieldSpec.start)
        else
          buffer.writeUInt8(0, fieldSpec.start)

  return buffer

encodeFieldLE = (buffer, obj, fieldSpec, padding) ->
  val = obj[fieldSpec.name]

  if !val? and fieldSpec.default?
    val = fieldSpec.default

  if val?
    switch fieldSpec.type
      when 'int8'   then buffer.writeInt8(val, fieldSpec.start)
      when 'uint8'  then buffer.writeUInt8(val, fieldSpec.start)
      when 'int16'  then buffer.writeInt16LE(val, fieldSpec.start)
      when 'uint16' then buffer.writeUInt16LE(val, fieldSpec.start)
      when 'float'  then buffer.writeFloatLE(val, fieldSpec.start)
      when 'double' then buffer.writeDoubleLE(val, fieldSpec.start)
      when 'uint32' then buffer.writeUInt32LE(val, fieldSpec.start)
      when 'int32'  then buffer.writeInt32LE(val, fieldSpec.start)
      when 'buffer' then val.copy(buffer, fieldSpec.start, 0, fieldSpec.length)

      when 'ascii', 'utf8'
        if padding?
          val = padEnd(val, fieldSpec.length, padding)

        buffer.write(val, fieldSpec.start, fieldSpec.length, fieldSpec.type)

      when 'bit'
        if val is true # protection from type problems
          buffer.writeUInt8(2 ** fieldSpec.position, fieldSpec.start)
        else
          buffer.writeUInt8(0, fieldSpec.start)

  return buffer

module.exports =
  findFieldLength:    findFieldLength
  findSpecBufferSize: findSpecBufferSize
  encodeFieldBE:      encodeFieldBE
  encodeFieldLE:      encodeFieldLE

