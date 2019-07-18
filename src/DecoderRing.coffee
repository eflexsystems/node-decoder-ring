fieldDecoder = require("./FieldDecoder")
fieldEncoder = require("./FieldEncoder")
defaults     = require('lodash.defaults')

class DecoderRing
  decode: (spec, buffer) ->
    obj = {}

    decodeFun =
      if spec.bigEndian
        fieldDecoder.decodeFieldBE
      else
        fieldDecoder.decodeFieldLE

    for field in spec.fields
      obj[field.name] = decodeFun(buffer, field)

    return obj

  encode: (spec, obj, options = {}) ->
    defaults options,
      padding:  null

    size = spec.length ? fieldEncoder.findSpecBufferSize(spec)
    buffer = Buffer.alloc(size)

    encodeFun =
      if spec.bigEndian
        fieldEncoder.encodeFieldBE
      else
        fieldEncoder.encodeFieldLE

    bitFieldAccumulator = {}

    for fieldSpec in spec.fields
      if fieldSpec.type is 'bit'
        val = if obj[fieldSpec.name] then 2 ** fieldSpec.position else 0
        currentVal = bitFieldAccumulator["#{fieldSpec.start}"] || 0
        bitFieldAccumulator["#{fieldSpec.start}"] = currentVal + val
      else
        buffer = encodeFun(buffer, obj, fieldSpec, options.padding)

    # encode all the bit fields that we accumulated
    for r in Object.keys(bitFieldAccumulator)
      buffer = encodeFun(
        buffer,
        bitFieldAccumulator,
        { name: r, start: parseInt(r), type: 'uint8' },
        options.padding
      )

    return buffer

module.exports = DecoderRing
