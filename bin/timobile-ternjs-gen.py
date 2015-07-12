#!/usr/bin/python

import sys
import os
import re
import yaml
import json

known_types = {
	'Number': 'numder',
	'String': 'string',
	'Boolean': 'bool'
}

def get_js_type(type):
	if isinstance(type, basestring):
		if type in known_types:
			return known_types[type]
		array_match = re.match(r'Array<(\w+)>', type)
		if array_match:
			sub_type = array_match.group(1)
			js_type = get_js_type(sub_type)
			if js_type:
				return '[%s]' % js_type
	if isinstance(type, list) and len(type) > 0:
		return get_js_type(type[0])

	return '+%s' % type

def get_fn_type(method_dict):
	params = ''
	if 'parameters' in method_dict:
		params = ', '.join(['%s: %s' % (param['name'], get_js_type(param['type'])) for param in method_dict['parameters']])
	ret = ''
	if 'returns' in method_dict:
		returns_dict = method_dict['returns']
		if isinstance(returns_dict, dict):
			ret = ' -> %s' % get_js_type(returns_dict['type'])
	return 'fn(%s)%s' % (params, ret)

def fill_properties(properties, curr_type_name, dict):
	for property in properties:
		prop_descriptor = {}
		prop_name = property['name']
		if 'type' in property:
			yaml_prop_type = property['type']
			# Small precaution in order to avoid the same name for both type and property,
			# for example, type: Titanium.Android.R and property: Titanium.Android.R.
			# FIXME: Resolve it somehow, probably with local type definitions.
			if yaml_prop_type != '%s.%s' % (curr_type_name, prop_name):
				prop_descriptor['!type'] = get_js_type(yaml_prop_type)
		if 'summary' in property:
			prop_descriptor['!doc'] = property['summary']
		dict[prop_name] = prop_descriptor

def fill_methods(methods, dict):
	for method in methods:
		method_descriptor = {}
		if 'summary' in method:
			method_descriptor['!doc'] = method['summary']
		fn_type = get_fn_type(method)
		if fn_type:
			method_descriptor['!type'] = fn_type
		dict[method['name']] = method_descriptor

def parse_yaml_doc(doc, result):
	curr_dict = result
	doc_name = doc['name']
	sections = doc_name.split('.')
	last_section = None

	# Generate namespace hierarchy.
	for section in sections:
		last_section = section
		if section == 'Global':
			continue
		if not section in curr_dict:
			new_dict = {}
			curr_dict[section] = new_dict
			curr_dict = new_dict
		else:
			curr_dict = curr_dict[section]

	# Generate summary, properties and methods documentation.
	curr_dict['!doc'] = doc['summary']
	curr_dict['!url'] = 'http://docs.appcelerator.com/titanium/latest/#!/api/%s' % doc_name

	prototype_dict = None
	if not 'extends' in doc or doc['extends'] == 'Titanium.Module':
		prototype_dict = curr_dict
	else:
		prototype_dict = {}
		curr_dict['prototype'] = prototype_dict
		prototype_dict['!proto'] = '%s.prototype' % doc['extends']

	if 'properties' in doc:
		fill_properties(doc['properties'], doc_name, prototype_dict)

	if 'methods' in doc:
		fill_methods(doc['methods'], prototype_dict)

	if not 'createable' in doc or doc['createable']:
		return {
			'name': 'create%s' % last_section,
			'returns': {
				'type': doc_name
			}
		}

def read_yaml_file(file, result):
	print 'Reading %s' % file
	create_methods = []
	f = open(file)
	docs = yaml.load_all(f)
	for doc in docs:
		create_method = parse_yaml_doc(doc, result)
		if create_method:
			create_methods.append(create_method)
	f.close()
	fill_methods(create_methods, result['Titanium']['UI'])

# Check console args.
if len(sys.argv) < 3:
	print 'Usage: %s <yaml_dir> <output_file>' % sys.argv[0]
	exit(1)

yaml_dir = sys.argv[1]
output_file = sys.argv[2]

# Result stub.
result = {
	# Module name.
	'name': 'titanium',
	'Titanium': {
		'UI': { }
	},
	# Make a global Ti alias to Titanium.
	'Ti': {
		'!proto': 'Titanium'
	}
}

# Enumerate all files recursively starting from yaml_dir.
for root, dir, files in os.walk(yaml_dir):
	for file in files:
		if file.endswith('.yml'):
			read_yaml_file(os.path.join(root, file), result)

print 'Writing result to %s' % output_file
f = open(output_file, 'w')
f.write(json.dumps(result, indent=4, separators=(',', ': ')))
f.close()
