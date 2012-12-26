RSpec::Matchers.define :expose do |expected|
  match do |entity|
    entity.exposures.keys.include?(expected)
  end

  failure_message_for_should do |entity|
    "expected that #{entity} would exposure :#{expected}"
  end

  description do |entity|
    str = "expose :#{expected}"

    doc = entity.documentation[expected]
    str << " [#{doc[:type]}] #{doc[:desc]}" if doc

    str
  end
end
