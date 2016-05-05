# coding: utf-8

require 'json'
require 'rexml/document'

def json_to_xml( json_str )
	hash = JSON.parse( json_str )
	if hash.keys.size > 1
		raise 'root key size must be 1'
	end
	#doc_xml = REXML::Document.new( "<#{hash.keys.first} />" )
	doc_xml = REXML::Document.new
	json_to_xml_recursive( hash.keys.first, hash.values.first, doc_xml )
	return doc_xml.to_s
end

def json_to_xml_recursive( _key, _value, _doc_xml )
	doc_xml = _doc_xml.add_element( _key )
	case _value
	when Hash
		_value.each{ |key, value|
			case value
			when Hash
				json_to_xml_recursive( key, value, doc_xml )
			when Array
				value.each{ |hash|
					json_to_xml_recursive( key, hash, doc_xml )
				}
			else
				doc_xml.add_element( key ).add_text value
			end
		}
	else
		raise "case value when other than Hash is not implemented"
	end
end


if __FILE__ == $0
	json_str = '{"config": {"a": [{"b1": {"c1": "c1"}}, {"b2": {"c2": "c2"}}]}}'
	puts json_to_xml( json_str )
	json_str = '{"config":{"leaf1":"0"}}'
	puts json_to_xml( json_str )
end
