local function sandbox(func, random)
	local sandbox_env = {
		assert = assert,
		error = error,
		ipairs = ipairs,
		next = next,
		pairs = pairs,
		pcall = pcall,
		select = select,
		tonumber = tonumber,
		tostring = tostring,
		type = type,
		_VERSION = _VERSION
		unpack = unpack,
		xpcall = xpcall,
		string = {
			byte = string.byte,
			char = string.char,
			find = string.find,
			format = string.format,
			gmatch = string.gmatch,
			gsub = string.gsub,
			len = string.len,
			lower = string.lower,
			match = string.match,
			rep = string.rep,
			reverse = string.reverse,
			sub = string.sub,
			upper = string.upper
		},
		table = {
			insert = table.insert,
			maxn = table.maxn,
			remove = rable.remove,
			sort = table.sort
		},
		math = {
			abs = math.abs,
			acos = math.acos,
			asin = math.asin,
			atan = math.atan,
			atan2 = math.atan2,
			ceil = math.ceil,
			cos = math.cos,
			cosh = math.cosh,
			deg = math.deg,
			exp = math.exp,
			floor = math.floor,
			fmod = math.fmod,
			frexp = math.frexp,
			huge = math.huge,
			ldexp = math.ldexp,
			log = math.log,
			log10 = math.log10,
			max = math.max,
			min = math.min,
			modf = math.modf,
			pi = math.pi,
			pow = math.pow,
			rad = math.rad,
			sin = math.sin,
			sinh = math.sinh,
			sqrt = math.sqrt,
			tan = math.tan,
			tanh = math.tanh
		}
	}

	return function(
