class_name GlobalScopeX
extends RefCounted
## A singleton for providing general-purpose utility API.

## Represents the smallest possible difference between two double precision
## floating point numbers.
const EPSILON_DOUBLE_PRECISION: float = 2.0 ** -52.0

## Represents the smallest possible difference between two single precision
## floating point numbers.
const EPSILON_SINGLE_PRECISION: float = 2.0 ** -22.0


static func fetch(
		use_tls: bool,
		host: String,
		port: int,
		path: String,
		method: int = HTTPClient.METHOD_GET,
		headers: Dictionary[String, String] = { },
) -> Variant:
	var client = HTTPClient.new()
	var scene_tree = Engine.get_main_loop()
	var tls_options = TLSOptions.client() if use_tls else null

	var error = client.connect_to_host(host, port, tls_options)

	if error != OK:
		push_error(
			"bad arguments #0, #1, or #2 to 'GlobalScopeX.fetch' (failed to establish" \
			+ " a connection to '" + host + ":" + str(port) + "')",
		)

		return null

	while client.get_status() == HTTPClient.STATUS_CONNECTING \
	or client.get_status() == HTTPClient.STATUS_RESOLVING:
		client.poll()
		await scene_tree.process_frame

	if client.get_status() != HTTPClient.STATUS_CONNECTED:
		push_error(
			"bad arguments #0, #1, or #2 to 'GlobalScopeX.fetch' (failed to resolve" \
			+ " a connection to '" + host + ":" + str(port) + "')",
		)

		return null

	var packed_headers = PackedStringArray()

	for key in headers:
		packed_headers.append("%s: %s" % [key, headers[key]])

	error = client.request(method, path, packed_headers)

	if error != OK:
		push_error(
			"bad arguments #3, #4, or #5 to 'GlobalScopeX.fetch' (request could not be sent)",
		)

		return null

	while client.get_status() == HTTPClient.STATUS_REQUESTING:
		client.poll()
		await scene_tree.process_frame

	if !client.has_response():
		return {
			"headers": client.get_response_headers_as_dictionary(),
			"body": null,
		}

	var response_body = PackedByteArray()

	while client.get_status() == HTTPClient.STATUS_BODY:
		client.poll()

		var chunk = client.read_response_body_chunk()

		if chunk.size() <= 0:
			await scene_tree.process_frame
			continue

		response_body.append_array(chunk)

	return {
		"headers": client.get_response_headers_as_dictionary(),
		"body": response_body,
	}


static func fetch_json(
		use_tls: bool,
		host: String,
		port: int,
		path: String,
		method: int = HTTPClient.METHOD_GET,
		headers: Dictionary[String, String] = { },
) -> Variant:
	var json = JSON.new()
	var json_headers = headers.duplicate()

	json_headers.Accept = "application/json"

	var response = await fetch_utf8_string(
		use_tls,
		host,
		port,
		path,
		method,
		json_headers,
	)

	if response == null:
		return null

	var body = response.body as String

	response.body = json.get_data() if json.parse(body) == OK else null
	return response


static func fetch_utf8_string(
		use_tls: bool,
		host: String,
		port: int,
		path: String,
		method: int = HTTPClient.METHOD_GET,
		headers: Dictionary[String, String] = { },
) -> Variant:
	var response = await fetch(use_tls, host, port, path, method, headers)

	if response == null:
		return null

	var body = response.body

	if body == null:
		push_error(
			"bad dispatch to 'GlobalScopeX.fetch_utf8_string' (response body was 'null')",
		)

		return null

	response.body = (body as PackedByteArray).get_string_from_utf8()
	return response
