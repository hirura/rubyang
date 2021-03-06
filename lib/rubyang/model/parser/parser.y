class Rubyang::Model::Parser

token
	STRING

rule
	statement			:	"module-stmt"
					|	"submodule-stmt"

	"module-stmt"			:	"module-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"module-header-stmts"
							"linkage-stmts"
							"meta-stmts"
							"revision-stmts"
							"body-stmts"
						"}"
							{
								substmts = val[3..-2].inject( [] ){ |ss, s| ss + s }
								result   = Rubyang::Model::Module.new( val[1], substmts )
							}

	"submodule-stmt"		:	"submodule-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"submodule-header-stmts"
							"linkage-stmts"
							"meta-stmts"
							"revision-stmts"
							"body-stmts"
						"}"
							{
								substmts = val[3..-2].inject( [] ){ |ss, s| ss + s }
								result   = Rubyang::Model::Submodule.new( val[1], substmts )
							}

	"module-header-stmts"		:	/*  */
							{
								result = []
							}
					|	"module-header-stmts" "module-header-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"module-header-stmt"		:	"yang-version-stmt"
					|	"namespace-stmt"
					|	"prefix-stmt"

	"submodule-header-stmts"	:	/*  */
							{
								result = []
							}
					|	"submodule-header-stmts" "submodule-header-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"submodule-header-stmt"		:	"yang-version-stmt"
					|	"belongs-to-stmt"

	"meta-stmts"			:	/*  */
							{
								result = []
							}
					|	"meta-stmts" "meta-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"meta-stmt"			:	"organization-stmt"
					|	"contact-stmt"
					|	"description-stmt"
					|	"reference-stmt"

	"linkage-stmts"			:	/*  */
							{
								result = []
							}
					|	"linkage-stmts" "linkage-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"linkage-stmt"			:	"import-stmt"
					|	"include-stmt"

	"revision-stmts"		:	/*  */
							{
								result = []
							}
					|	"revision-stmts" "revision-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"body-stmts"			:	/*  */
							{
								result = []
							}
					|	"body-stmts" "body-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"body-stmt"			:	"extension-stmt"
					|	"feature-stmt"
					|	"identity-stmt"
					|	"typedef-stmt"
					|	"grouping-stmt"
					|	"data-def-stmt"
					|	"augment-stmt"
					|	"rpc-stmt"
					|	"notification-stmt"
					|	"deviation-stmt"

	"data-def-stmt"			:	"container-stmt"
					|	"leaf-stmt"
					|	"leaf-list-stmt"
					|	"list-stmt"
					|	"choice-stmt"
					|	"anyxml-stmt"
					|	"uses-stmt"

	"yang-version-stmt"		:	"yang-version-keyword" "yang-version-arg-str" "stmtend"
							{
								result = Rubyang::Model::YangVersion.new( val[1], val[2] )
							}

	"yang-version-arg-str"		:	"string"
							{
								unless val[0] == "1"
									raise ParseError, "yang-version must be '1', but '#{val[0]}'"
								end
								result = val[0]
							}

	"import-stmt"			:	"import-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"inner-import-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Import.new( val[1], substmts )
							}

	"inner-import-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-import-stmts" "inner-import-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"inner-import-stmt"		:	"prefix-stmt"
					|	"revision-date-stmt"

	"include-stmt"			:	"include-keyword" "identifier-arg-str" ";"
							{
								result = Rubyang::Model::Include.new( val[1] )
							}
					|	"include-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"inner-include-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Include.new( val[1], substmts )
							}

	"inner-include-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-include-stmts" "inner-include-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"inner-include-stmt"		:	"revision-date-stmt"

	"namespace-stmt"		:	"namespace-keyword" "uri-str" "stmtend"
							{
								result = Rubyang::Model::Namespace.new( val[1], val[2] )
							}

	"uri-str"			:	"string"
							{
								unless val[0] == URI.regexp.match( val[0] ).to_s
									raise ParseError, "namespace statement's argument must be URI"
								end
								result = val[0]
							}

	"prefix-stmt"			:	"prefix-keyword" "prefix-arg-str" "stmtend"
							{
								result = Rubyang::Model::Prefix.new( val[1], val[2] )
							}

	"belongs-to-stmt"		:	"belongs-to-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"prefix-stmt" "stmtsep"
						"}"
							{
								substmts = val[3] + [val[4]] + val[5]
								result = Rubyang::Model::BelongsTo.new( val[1], substmts )
							}

	"organization-stmt"		:	"organization-keyword" "string" "stmtend"
							{
								result = Rubyang::Model::Organization.new( val[1], val[2] )
							}

	"contact-stmt"			:	"contact-keyword" "string" "stmtend"
							{
								result = Rubyang::Model::Contact.new( val[1], val[2] )
							}

	"description-stmt"		:	"description-keyword" "string" "stmtend"
							{
								result = Rubyang::Model::Description.new( val[1], val[2] )
							}

	"reference-stmt"		:	"reference-keyword" "string" "stmtend"
							{
								result = Rubyang::Model::Reference.new( val[1], val[2] )
							}

	"units-stmt"			:	"units-keyword" "string" "stmtend"
							{
								result = Rubyang::Model::Units.new( val[1], val[2] )
							}

	"revision-stmt"			:	"revision-keyword" "revision-date" ";"
							{
								result = Rubyang::Model::Revision.new( val[1] )
							}
					|	"revision-keyword" "revision-date"
						"{"
							"stmtsep"
							"inner-revision-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Revision.new( val[1], substmts )
							}

	"inner-revision-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-revision-stmts" "inner-revision-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"inner-revision-stmt"		:	"description-stmt"
					|	"reference-stmt"

	"revision-date"			:	"date-arg-str"

	"revision-date-stmt"		:	"revision-date-keyword" "revision-date" "stmtend"
							{
								result = Rubyang::Model::RevisionDate.new( val[1], val[2] )
							}

	"extension-stmt"		:	"extension-keyword" "identifier-arg-str" ";"
							{
								result = Rubyang::Model::Extension.new( val[1] )
							}
					|	"extension-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"inner-extension-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Extension.new( val[1], substmts )
							}

	"inner-extension-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-extension-stmts" "inner-extension-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"inner-extension-stmt"		:	"argument-stmt"
					|	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"

	"argument-stmt"			:	"argument-keyword" "identifier-arg-str" ";"
							{
								result = Rubyang::Model::Argument.new( val[1] )
							}
					|	"argument-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"inner-argument-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Argument.new( val[1], substmts )
							}

	"inner-argument-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-argument-stmts" "inner-argument-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"inner-argument-stmt"		:	"yin-element-stmt"

	"yin-element-stmt"		:	"yin-element-keyword" "yin-element-arg-str" "stmtend"
							{
								result = Rubyang::Model::YinElement.new( val[1], val[2] )
							}

	"yin-element-arg-str"		:	"string"
							{
								unless ['true', 'false'].include? val[0]
									raise Racc::ParseError, "yin-element-arg-str must be 'true' or 'false', but '#{val[0]}'"
								end
								result = val[0]
							}

	"identity-stmt"			:	"identity-keyword" "identifier-arg-str" ";"
							{
								result = Rubyang::Model::Identity.new( val[1] )
							}
					|	"identity-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"inner-identity-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Identity.new( val[1], substmts )
							}

	"inner-identity-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-identity-stmts" "inner-identity-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"inner-identity-stmt"		:	"base-stmt"
					|	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"

	"base-stmt"			:	"base-keyword" "identifier-ref-arg-str" "stmtend"
							{
								result = Rubyang::Model::Base.new( val[1], val[2] )
							}

	"feature-stmt"			:	"feature-keyword" "identifier-arg-str" ";"
							{
								result = Rubyang::Model::Feature.new( val[1] )
							}
					|	"feature-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"inner-feature-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Feature.new( val[1], substmts )
							}

	"inner-feature-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-feature-stmts" "inner-feature-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"inner-feature-stmt"		:	"if-feature-stmt"
					|	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"

	"if-feature-stmt"		:	"if-feature-keyword" "identifier-ref-arg-str" "stmtend"
							{
								result = Rubyang::Model::IfFeature.new( val[1], val[2] )
							}

	"typedef-stmt"			:	"typedef-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"inner-typedef-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Typedef.new( val[1], substmts )
							}

	"inner-typedef-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-typedef-stmts" "inner-typedef-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"inner-typedef-stmt"		:	"type-stmt"
					|	"units-stmt"
					|	"default-stmt"
					|	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"

	"type-stmt"			:	"type-keyword" "identifier-ref-arg-str" ";"
							{
								result = Rubyang::Model::Type.new( val[1] )
							}
					|	"type-keyword" "identifier-ref-arg-str"
						"{"
							"stmtsep"
							"type-body-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Type.new( val[1], substmts )
							}

	"type-body-stmts"		:	"numerical-restrictions"
					|	"decimal64-specification"
					|	"string-restrictions"
					|	"enum-specification"
					|	"leafref-specification"
					|	"identityref-specification"
					|	"instance-identifier-specification"
					|	"bits-specification"
					|	"union-specification"

	"numerical-restrictions"	:	"range-stmt" "stmtsep"
							{
								result = [val[0]] + val[1]
							}

	"range-stmt"			:	"range-keyword" "range-arg-str" ";"
							{
								result = Rubyang::Model::Range.new( val[1] )
							}
					|	"range-keyword" "range-arg-str"
						"{"
							"stmtsep"
							"inner-range-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Range.new( val[1], substmts )
							}

	"inner-range-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-range-stmts" "inner-range-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"inner-range-stmt"		:	"error-message-stmt"
					|	"error-app-tag-stmt"
					|	"description-stmt"
					|	"reference-stmt"

	"decimal64-specification"	:	"fraction-digits-stmt" "stmtsep"
							{
								result = [val[0]] + val[1]
							}
					|	"fraction-digits-stmt" "stmtsep"
						"range-stmt" "stmtsep"
							{
								result = [val[0]] + val[1] + [val[2]] + val[3]
							}
					|	"range-stmt" "stmtsep"
						"fraction-digits-stmt" "stmtsep"
							{
								result = [val[0]] + val[1] + [val[2]] + val[3]
							}

	"fraction-digits-stmt"		:	"fraction-digits-keyword" "fraction-digits-arg-str" "stmtend"
							{
								result = Rubyang::Model::FractionDigits.new( val[1], val[2] )
							}

	"fraction-digits-arg-str"	:	"string"
							{
								unless /^(1[012345678]?|[23456789])$/ =~ val[0]
									raise Racc::ParseError, "fraction digits' must be in 1..18, but '#{val[0]}'"
								end
								result = val[0]
							}

	"string-restrictions"		:	/*  */
							{
								result = []
							}
					|	"string-restrictions" "string-restriction" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"string-restriction"		:	"length-stmt"
					|	"pattern-stmt"

	"length-stmt"			:	"length-keyword" "length-arg-str" ";"
							{
								result = Rubyang::Model::Length.new( val[1] )
							}
					|	"length-keyword" "length-arg-str"
						"{"
							"stmtsep"
							"inner-length-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Length.new( val[1], substmts )
							}

	"inner-length-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-length-stmts" "inner-length-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"inner-length-stmt"		:	"error-message-stmt"
					|	"error-app-tag-stmt"
					|	"description-stmt"
					|	"reference-stmt"

	"pattern-stmt"			:	"pattern-keyword" "string" ";"
							{
								result = Rubyang::Model::Pattern.new( val[1] )
							}
					|	"pattern-keyword" "string"
						"{"
							"stmtsep"
							"inner-pattern-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Pattern.new( val[1], substmts )
							}

	"inner-pattern-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-pattern-stmts" "inner-pattern-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"inner-pattern-stmt"		:	"error-message-stmt"
					|	"error-app-tag-stmt"
					|	"description-stmt"
					|	"reference-stmt"

	"default-stmt"			:	"default-keyword" "string" "stmtend"
							{
								result = Rubyang::Model::Default.new( val[1], val[2] )
							}

	"enum-specification"		:	"enum-stmt" "stmtsep"
							{
								result = [val[0]] + val[1]
							}
					|	"enum-specification" "enum-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"enum-stmt"			:	"enum-keyword" "string" ";"
							{
								result = Rubyang::Model::Enum.new( val[1] )
							}
					|	"enum-keyword" "string"
						"{"
							"stmtsep"
							"inner-enum-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Enum.new( val[1], substmts )
							}

	"inner-enum-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-enum-stmts" "inner-enum-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"inner-enum-stmt"		:	"value-stmt"
					|	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"

	"leafref-specification"		:	"path-stmt" "stmtsep"
							{
								result = [val[0]]
							}
					|	"path-stmt" "stmtsep"
						"require-instance-stmt" "stmtsep"
							{
								result = [val[0]] + val[1] + [val[2]] + val[3]
							}
					|	"require-instance-stmt" "stmtsep"
						"path-stmt" "stmtsep"
							{
								result = [val[0]] + val[1] + [val[2]] + val[3]
							}

	"path-stmt"			:	"path-keyword" "path-arg-str" "stmtend"
							{
								result = Rubyang::Model::Path.new( val[1], val[2] )
							}

	"require-instance-stmt"		:	"require-instance-keyword" "require-instance-arg-str" "stmtend"
							{
								result = Rubyang::Model::RequireInstance.new( val[1], val[2] )
							}

	"require-instance-arg-str"	:	"string"
							{
								unless ['true', 'false'].include? val[0]
									raise Racc::ParseError, "require-instance-arg-str must be 'true' or 'false', but '#{val[0]}'"
								end
								result = val[0]
							}

	"instance-identifier-specification"	:	"require-instance-stmt" "stmtsep"
							{
								result = [val[0]] + val[1]
							}

	"identityref-specification"	:	"base-stmt" "stmtsep"
							{
								result = [val[0]] + val[1]
							}

	"union-specification"		:	"type-stmt" "stmtsep"
							{
								result = [val[0]] + val[1]
							}
					|	"union-specification" "type-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"bits-specification"		:	"bit-stmt" "stmtsep"
							{
								result = [val[0]] + val[1]
							}
					|	"bits-specification" "bit-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"bit-stmt"			:	"bit-keyword" "identifier-arg-str" ";"
							{
								result = Rubyang::Model::Bit.new( val[1] )
							}
					|	"bit-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"inner-bit-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Bit.new( val[1], substmts )
							}

	"inner-bit-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-bit-stmts" "inner-bit-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"inner-bit-stmt"		:	"position-stmt"
					|	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"

	"position-stmt"			:	"position-keyword" "position-value-arg-str" "stmtend"
							{
								result = Rubyang::Model::Position.new( val[1], val[2] )
							}

	"position-value-arg-str"	:	"string"
							{
								unless /^[0-9]+$/ =~ val[0]
									raise "position-value-arg-str must be non-negative-integer-value"
								end
								result = val[0]
							}

	"status-stmt"			:	"status-keyword" "status-arg-str" "stmtend"
							{
								result = Rubyang::Model::Status.new( val[1], val[2] )
							}

	"status-arg-str"		:	"string"
							{
								unless ['current', 'obsolete', 'deprecated'].include? val[0]
									raise Racc::ParseError, "status-arg-str must be 'current' or 'obsolete' or 'deprecated', but '#{val[0]}'"
								end
								result = val[0]
							}

	"config-stmt"			:	"config-keyword" "config-arg-str" "stmtend"
							{
								result = Rubyang::Model::Config.new( val[1], val[2] )
							}

	"config-arg-str"		:	"string"
							{
								unless ['true', 'false'].include? val[0]
									raise "config-arg-str must be 'true' or 'false'"
								end
								result = val[0]
							}

	"mandatory-stmt"		:	"mandatory-keyword" "mandatory-arg-str" "stmtend"
							{
								result = Rubyang::Model::Mandatory.new( val[1], val[2] )
							}

	"mandatory-arg-str"		:	"string"
							{
								unless ['true', 'false'].include? val[0]
									raise "mandatory-arg-str must be 'true' or 'false'"
								end
								result = val[0]
							}

	"presence-stmt"			:	"presence-keyword" "string" "stmtend"
							{
								result = Rubyang::Model::Presence.new( val[1], val[2] )
							}

	"ordered-by-stmt"		:	"ordered-by-keyword" "ordered-by-arg-str" "stmtend"
							{
								result = Rubyang::Model::OrderedBy.new( val[1], val[2] )
							}

	"ordered-by-arg-str"		:	"string"
							{
								unless ['user', 'system'].include? val[0]
									raise "ordered-by-arg-str must be 'user' or 'system'"
								end
								result = val[0]
							}

	"must-stmt"			:	"must-keyword" "string" ";"
							{
								result = Rubyang::Model::Must.new( val[1] )
							}
					|	"must-keyword" "string"
						"{"
							"stmtsep"
							"inner-must-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Must.new( val[1], substmts )
							}

	"inner-must-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-must-stmts" "inner-must-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"inner-must-stmt"		:	"error-message-stmt"
					|	"error-app-tag-stmt"
					|	"description-stmt"
					|	"reference-stmt"

	"error-message-stmt"		:	"error-message-keyword" "string" "stmtend"
							{
								result = Rubyang::Model::ErrorMessage.new( val[1], val[2] )
							}

	"error-app-tag-stmt"		:	"error-app-tag-keyword" "string" "stmtend"
							{
								result = Rubyang::Model::ErrorAppTag.new( val[1], val[2] )
							}

	"min-elements-stmt"		:	"min-elements-keyword" "min-value-arg-str" "stmtend"
							{
								result = Rubyang::Model::MinElements.new( val[1], val[2] )
							}

	"min-value-arg-str"		:	"string"
							{
								unless /^[0-9]+$/ =~ val[0]
									raise "min-value-arg-str must be non-negative-integer-value"
								end
								result = val[0]
							}

	"max-elements-stmt"		:	"max-elements-keyword" "max-value-arg-str" "stmtend"
							{
								result = Rubyang::Model::MaxElements.new( val[1], val[2] )
							}

	"max-value-arg-str"		:	"string"
							{
								unless /^(unbounded|[0-9]+)$/ =~ val[0]
									raise "max-value-arg-str must be 'unbounded' or non-negative-integer-value"
								end
								result = val[0]
							}

	"value-stmt"			:	"value-keyword" "integer-value" "stmtend"
							{
								result = Rubyang::Model::Value.new( val[1], val[2] )
							}

	"grouping-stmt"			:	"grouping-keyword" "identifier-arg-str" ";"
							{
								result = Rubyang::Model::Grouping.new( val[1] )
							}
					|	"grouping-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"inner-grouping-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Grouping.new( val[1], substmts )
							}

	"inner-grouping-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-grouping-stmts" "inner-grouping-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"inner-grouping-stmt"		:	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"
					|	"typedef-stmt"
					|	"grouping-stmt"
					|	"data-def-stmt"

	"container-stmt"		:	"container-keyword" "identifier-arg-str" ";"
							{
								result = Rubyang::Model::Container.new( val[1] )
							}
					|	"container-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"inner-container-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Container.new( val[1], substmts )
							}

	"inner-container-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-container-stmts" "inner-container-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"inner-container-stmt"		:	"when-stmt"
					|	"if-feature-stmt"
					|	"must-stmt"
					|	"presence-stmt"
					|	"config-stmt"
					|	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"
					|	"typedef-stmt"
					|	"grouping-stmt"
					|	"data-def-stmt"

	"leaf-stmt"			:	"leaf-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"inner-leaf-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Leaf.new( val[1], substmts )
							}
	
	"inner-leaf-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-leaf-stmts" "inner-leaf-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}
	
	"inner-leaf-stmt"		:	"when-stmt"
					|	"if-feature-stmt"
					|	"type-stmt"
					|	"units-stmt"
					|	"must-stmt"
					|	"default-stmt"
					|	"config-stmt"
					|	"mandatory-stmt"
					|	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"

	"leaf-list-stmt"		:	"leaf-list-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"inner-leaf-list-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::LeafList.new( val[1], substmts )
							}
	
	"inner-leaf-list-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-leaf-list-stmts" "inner-leaf-list-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}
	
	"inner-leaf-list-stmt"		:	"when-stmt"
					|	"if-feature-stmt"
					|	"type-stmt"
					|	"units-stmt"
					|	"must-stmt"
					|	"config-stmt"
					|	"min-elements-stmt"
					|	"max-elements-stmt"
					|	"ordered-by-stmt"
					|	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"

	"list-stmt"			:	"list-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"inner-list-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::List.new( val[1], substmts )
							}
	
	"inner-list-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-list-stmts" "inner-list-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}
	
	"inner-list-stmt"		:	"when-stmt"
					|	"if-feature-stmt"
					|	"must-stmt"
					|	"key-stmt"
					|	"unique-stmt"
					|	"config-stmt"
					|	"min-elements-stmt"
					|	"max-elements-stmt"
					|	"ordered-by-stmt"
					|	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"
					|	"typedef-stmt"
					|	"grouping-stmt"
					|	"data-def-stmt"

	"key-stmt"			:	"key-keyword" "key-arg-str" "stmtend"
							{
								result = Rubyang::Model::Key.new( val[1], val[2] )
							}

	"key-arg-str"			:	"string"
							{
								unless /^(([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*(\s+(([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*)*$/ =~ val[0]
									raise ParseError, "bad key-arg-str"
								end
								result = val[0]
							}

	"unique-stmt"			:	"unique-keyword" "unique-arg-str" "stmtend"
							{
								result = Rubyang::Model::Unique.new( val[1], val[2] )
							}

	"unique-arg-str"		:	"unique-arg"

	"unique-arg"			:	"descendant-schema-nodeid"
					|	"unique-arg" "descendant-schema-nodeid"
							{
								result = val[0] + val[1]
							}

	"choice-stmt"			:	"choice-keyword" "identifier-arg-str" ";"
							{
								result = Rubyang::Model::Choice.new( val[1] )
							}
					|	"choice-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"inner-choice-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Choice.new( val[1], substmts )
							}

	"inner-choice-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-choice-stmts" "inner-choice-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"inner-choice-stmt"		:	"when-stmt"
					|	"if-feature-stmt"
					|	"default-stmt"
					|	"config-stmt"
					|	"mandatory-stmt"
					|	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"
					|	"short-case-stmt"
					|	"case-stmt"

	"short-case-stmt"		:	"container-stmt"
					|	"leaf-stmt"
					|	"leaf-list-stmt"
					|	"list-stmt"
					|	"anyxml-stmt"

	"case-stmt"			:	"case-keyword" "identifier-arg-str" ";"
							{
								result = Rubyang::Model::Case.new( val[1] )
							}
					|	"case-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"inner-case-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Case.new( val[1], substmts )
							}
	
	"inner-case-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-case-stmts" "inner-case-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}
	
	"inner-case-stmt"		:	"when-stmt"
					|	"if-feature-stmt"
					|	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"
					|	"data-def-stmt"

	"anyxml-stmt"			:	"anyxml-keyword" "identifier-arg-str" ";"
							{
								result = Rubyang::Model::Anyxml.new( val[1] )
							}
					|	"anyxml-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"inner-anyxml-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Anyxml.new( val[1], substmts )
							}
	
	"inner-anyxml-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-anyxml-stmts" "inner-anyxml-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}
	
	"inner-anyxml-stmt"		:	"when-stmt"
					|	"if-feature-stmt"
					|	"must-stmt"
					|	"config-stmt"
					|	"mandatory-stmt"
					|	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"

	"uses-stmt"			:	"uses-keyword" "identifier-ref-arg-str" ";"
							{
								result = Rubyang::Model::Uses.new( val[1] )
							}
					|	"uses-keyword" "identifier-ref-arg-str"
						"{"
							"stmtsep"
							"inner-uses-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Uses.new( val[1], substmts )
							}

	"inner-uses-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-uses-stmts" "inner-uses-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}

	"inner-uses-stmt"		:	"when-stmt"
					|	"if-feature-stmt"
					|	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"
					|	"refine-stmt"
					|	"uses-augment-stmt"

	"refine-stmt"			:	"refine-keyword" "refine-arg-str" ";"
							{
								result = Rubyang::Model::Refine.new( val[1] )
							}
					|	"refine-keyword" "refine-arg-str"
						"{"
							"stmtsep"
							"inner-refine-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Refine.new( val[1], substmts )
							}

	"inner-refine-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-refine-stmts" "inner-refine-stmt"
							{
								result = val[0] + [val[1]]
							}

	"inner-refine-stmt"		:	"must-stmt"
					|	"presence-stmt"
					|	"config-stmt"
					|	"description-stmt"
					|	"reference-stmt"
					|	"default-stmt"
					|	"mandatory-stmt"
					|	"min-elements-stmt"
					|	"max-elements-stmt"

	"refine-arg-str"		:	"refine-arg"

	"refine-arg"			:	"descendant-schema-nodeid"

	"uses-augment-stmt"		:	"augment-keyword" "uses-augment-arg-str"
						"{"
							"stmtsep"
							"inner-uses-augment-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Augment.new( val[1], substmts )
							}
	
	"inner-uses-augment-stmts"	:	/*  */
							{
								result = []
							}
					|	"inner-uses-augment-stmts" "inner-uses-augment-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}
	
	"inner-uses-augment-stmt"	:	"when-stmt"
					|	"if-feature-stmt"
					|	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"
					|	"data-def-stmt"
					|	"case-stmt"

	"uses-augment-arg-str"		:	"uses-augment-arg"

	"uses-augment-arg"		:	"descendant-schema-nodeid"

	"augment-stmt"			:	"augment-keyword" "augment-arg-str"
						"{"
							"stmtsep"
							"inner-augment-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Augment.new( val[1], substmts )
							}
	
	"inner-augment-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-augment-stmts" "inner-augment-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}
	
	"inner-augment-stmt"		:	"when-stmt"
					|	"if-feature-stmt"
					|	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"
					|	"data-def-stmt"
					|	"case-stmt"

	"augment-arg-str"		:	"augment-arg"

	"augment-arg"			:	"absolute-schema-nodeid"

	"unknown-stmts"			:	/*  */
							{
								result = []
							}
					|	"unknown-stmts" "unknown-stmt"
							{
								result = val[0] + [val[1]]
							}

	"unknown-stmt"			:	"prefixed-node-identifier" "unknown-arg-str" ";"
							{
								result = Rubyang::Model::Unknown.new( val[0], val[1] )
							}
					|	"prefixed-node-identifier" "unknown-arg-str" "{" "unknown-stmts2" "}"
							{
								substmts = val[3]
								result = Rubyang::Model::Unknown.new( val[0], val[1], substmts )
							}

	"unknown-stmts2"		:	/*  */
							{
								result = []
							}
					|	"unknown-stmts2" "unknown-stmt2"
							{
								result = val[0] + [val[1]]
							}

	"unknown-stmt2"			:	"node-identifier" "unknown-arg-str" ";"
							{
								result = Rubyang::Model::Unknown.new( val[0], val[1] )
							}
					|	"node-identifier" "unknown-arg-str" "{" "unknown-stmts2" "}"
							{
								substmts = val[3]
								result = Rubyang::Model::Unknown.new( val[0], val[1], substmts )
							}

	"unknown-arg-str"		:	/*  */
							{
								result = ''
							}
					|	"string"

	"when-stmt"			:	"when-keyword" "string" ";"
							{
								result = Rubyang::Model::When.new( val[1] )
							}
					|	"when-keyword" "string"
						"{"
							"stmtsep"
							"inner-when-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::When.new( val[1], substmts )
							}
	
	"inner-when-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-when-stmts" "inner-when-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}
	
	"inner-when-stmt"		:	"description-stmt"
					|	"reference-stmt"

	"rpc-stmt"			:	"rpc-keyword" "identifier-arg-str" ";"
							{
								result = Rubyang::Model::Rpc.new( val[1] )
							}
					|	"rpc-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"inner-rpc-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Rpc.new( val[1], substmts )
							}
	
	"inner-rpc-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-rpc-stmts" "inner-rpc-stmt"
							{
								result = val[0] + [val[1]]
							}
	
	"inner-rpc-stmt"		:	"if-feature-stmt"
					|	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"
					|	"typedef-stmt"
					|	"grouping-stmt"
					|	"input-stmt"
					|	"output-stmt"

	"input-stmt"			:	"input-keyword"
						"{"
							"stmtsep"
							"inner-input-stmts"
						"}"
							{
								substmts = val[2] + val[3]
								result = Rubyang::Model::Input.new( substmts )
							}
	
	"inner-input-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-input-stmts" "inner-input-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}
	
	"inner-input-stmt"		:	"typedef-stmt"
					|	"grouping-stmt"
					|	"data-def-stmt"

	"output-stmt"			:	"output-keyword"
						"{"
							"stmtsep"
							"inner-output-stmts"
						"}"
							{
								substmts = val[2] + val[3]
								result = Rubyang::Model::Output.new( substmts )
							}
	
	"inner-output-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-output-stmts" "inner-output-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}
	
	"inner-output-stmt"		:	"typedef-stmt"
					|	"grouping-stmt"
					|	"data-def-stmt"

	"notification-stmt"		:	"notification-keyword" "identifier-arg-str" ";"
							{
								result = Rubyang::Model::Notification.new( val[1] )
							}
					|	"notification-keyword" "identifier-arg-str"
						"{"
							"stmtsep"
							"inner-notification-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Notification.new( val[1], substmts )
							}
	
	"inner-notification-stmts"	:	/*  */
							{
								result = []
							}
					|	"inner-notification-stmts" "inner-notification-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}
	
	"inner-notification-stmt"	:	"if-feature-stmt"
					|	"status-stmt"
					|	"description-stmt"
					|	"reference-stmt"
					|	"typedef-stmt"
					|	"grouping-stmt"
					|	"data-def-stmt"

	"deviation-stmt"		:	"deviation-keyword" "deviation-arg-str" ";"
							{
								result = Rubyang::Model::Deviation.new( val[1] )
							}
					|	"deviation-keyword" "deviation-arg-str"
						"{"
							"stmtsep"
							"inner-deviation-stmts"
						"}"
							{
								substmts = val[3] + val[4]
								result = Rubyang::Model::Deviation.new( val[1], substmts )
							}
	
	"inner-deviation-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-deviation-stmts" "inner-deviation-stmt" "stmtsep"
							{
								result = val[0] + [val[1]] + val[2]
							}
	
	"inner-deviation-stmt"		:	"description-stmt"
					|	"reference-stmt"
					|	"typedef-stmt"
					|	"deviate-stmt"

	"deviation-arg-str"		:	"deviation-arg"

	"deviation-arg"			:	"absolute-schema-nodeid"

	"deviate-stmt"			:	"deviate-keyword" "deviate-arg-str" ";"
							{
								result = Rubyang::Model::Deviate.new( val[1] )
							}
					|	"deviate-keyword" "deviate-arg-str" "{" "inner-deviate-stmts" "}"
							{
								substmts = val[3]
								result = Rubyang::Model::Deviate.new( val[1], substmts )
							}

	"inner-deviate-stmts"		:	/*  */
							{
								result = []
							}
					|	"inner-deviate-stmts" "inner-deviate-stmt"
							{
								result = val[0] + [val[1]]
							}

	"inner-deviate-stmt"		:	"units-stmt"
					|	"must-stmt"
					|	"unique-stmt"
					|	"default-stmt"
					|	"config-stmt"
					|	"mandatory-stmt"
					|	"min-elements-stmt"
					|	"max-elements-stmt"
					|	"type-stmt"

	"deviate-arg-str"		:	"string"
							{
								unless ['not-supported', 'add', 'replace', 'delete'].include? val[0]
									raise "deviate statement's argument must be 'not-supported' or 'add' or 'replace' or 'delete', but '#{val[0]}'"
								end
								result = val[0]
							}

	"range-arg-str"			:	"string"
							{
								unless /^(min|max|[+-]?[0-9]+(\.[0-9]+)*)(\s*\.\.\s*(min|max|[+-]?[0-9]+(\.[0-9]+)*))*(\s*\|\s*(min|max|[+-]?[0-9]+(\.[0-9]+)*)(\s*\.\.\s*(min|max|[+-]?[0-9]+(\.[0-9]+)*))*)*$/ =~ val[0]
									raise "bad range-arg-str, but '#{val[0]}"
								end
								result = val[0]
							}

	"length-arg-str"		:	"string"
							{
								unless /^(min|max|[+]?[0-9]+)(\s*\.\.\s*(min|max|[+]?[0-9]+))*(\s*\|\s*(min|max|[+]?[0-9]+)(\s*\.\.\s*(min|max|[+]?[0-9]+))*)*$/ =~ val[0]
									raise "bad length-arg-str, but '#{val[0]}'"
								end
								result = val[0]
							}

	"date-arg-str"			:	"string"
							{
								unless /^\d\d\d\d-\d\d-\d\d$/ =~ val[0]
									raise ParseError, "bad date-arg-str"
								end
								result = val[0]
							}

	"absolute-schema-nodeid"	:	"string"
							{
								unless /^\/(([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*(\/(([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*)*$/ =~ val[0]
									raise ParseError, "bad absolute-schema-nodeid"
								end
								result = val[0]
							}

	"descendant-schema-nodeid"	:	"string"
							{
								unless /^(([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*(\/(([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*)*$/ =~ val[0]
									raise ParseError, "bad absolute-schema-nodeid"
								end
								result = val[0]
							}

	"node-identifier"		:	"string"
							{
								unless /^(([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*/ =~ val[0]
									raise ParseError, "bad identifier"
								end
								result = val[0]
							}

	"prefixed-node-identifier"	:	"string"
							{
								unless /^([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:([a-zA-Z]|_)[a-zA-Z0-9_\.-]*/ =~ val[0]
									raise ParseError, "bad prefix:identifier"
								end
								result = val[0]
							}

	"path-arg-str"			:	"string"
							{
								unless /^(\/(([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*(\[\s*(([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*\s*=\s*current\s*\(\s*\)\s*\/\s*(\.\.\s*\/\s*)+((([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*\s*\/\s*)*(([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*\s*\])*)+$/ =~ val[0] || /^(\.\.\/)+(([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*((\[\s*(([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*\s*=\s*current\s*\(\s*\)\s*\/\s*(\.\.\s*\/\s*)+((([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*\s*\/\s*)*(([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*\s*\])*(\/(([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*(\[\s*(([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*\s*=\s*current\s*\(\s*\)\s*\/\s*(\.\.\s*\/\s*)+((([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*\s*\/\s*)*(([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*\s*\])*)+)?$/ =~ val[0]
									raise ParseError, "bad path-arg-str, but '#{val[0]}'"
								end
								result = val[0]
							}

	"prefix-arg-str"		:	"prefix-arg"

	"prefix-arg"			:	"prefix"

	"prefix"			:	"identifier"

	"identifier-arg-str"		:	"identifier-arg"

	"identifier-arg"		:	"identifier"

	"identifier"			:	"string"
							{
								unless /^([a-zA-Z]|_)[a-zA-Z0-9_\.-]*$/ =~ val[0]
									raise ParseError, "bad identifier-arg-str"
								end
								result = val[0]
							}

	"identifier-ref-arg-str"	:	"string"
							{
								unless /^(([a-zA-Z]|_)[a-zA-Z0-9_\.-]*:)?([a-zA-Z]|_)[a-zA-Z0-9_\.-]*$/ =~ val[0]
									raise ParseError, "bad identifier-ref-arg-str"
								end
								result = val[0]
							}

	"integer-value"			:	"string"
							{
								unless /^-?(?:[1-9][0-9]*)|0$/ =~ val[0]
									raise ParseError, "bad integer-value, but '#{val[0]}'"
								end
								result = val[0]
							}

	"string"			:	STRING
					|	"string" "+" STRING
							{
								result = val[0] + val[2]
							}

	"stmtsep"			:	"unknown-stmts"

	"stmtend"			:	";"
							{
								result = []
							}
					|	"{" "unknown-stmts" "}"
							{
								result = val[1]
							}
end
