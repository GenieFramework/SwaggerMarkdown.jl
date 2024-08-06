function merge_retaining(dict1, dict2)
  result = Dict{String, Any}()
  keys1 = keys(dict1)
  keys2 = keys(dict2)
  common_keys = intersect(keys1, keys2)
  individual_keys1 = intersect(keys1, symdiff(keys1, keys2))
  individual_keys2 = intersect(keys2, symdiff(keys1, keys2))

  for key ∈ common_keys
      result[key] = merge_retaining(dict1[key], dict2[key])
  end

  for key ∈ individual_keys1
      result[key] = dict1[key]
  end

  for key ∈ individual_keys2
      result[key] = dict2[key]
  end

  return result
end