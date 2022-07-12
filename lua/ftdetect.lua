ftdetect = {}

ftdetect.filetypes = {
	actionscript = {
		ext = { "%.as$", "%.asc$" },
	},
	ada = {
		ext = { "%.adb$", "%.ads$" },
	},
	ansi_c = {
		ext = { "%.c$", "%.C$", "%.h$" },
		mime = { "text/x-c" },
	},
	antlr = {
		ext = { "%.g$", "%.g4$" },
	},
	apdl = {
		ext = { "%.ans$", "%.inp$", "%.mac$" },
	},
	apl = {
		ext = { "%.apl$" }
	},
	applescript = {
		ext = { "%.applescript$" },
	},
	asm = {
		ext = { "%.asm$", "%.ASM$", "%.s$", "%.S$" },
	},
	asp = {
		ext = { "%.asa$", "%.asp$", "%.hta$" },
	},
	autoit = {
		ext = { "%.au3$", "%.a3x$" },
	},
	awk = {
		hashbang = { "^/usr/bin/[mng]awk%s+%-f" },
		utility = { "^[mgn]?awk$", "^goawk$" },
		ext = { "%.awk$" },
	},
	bash = {
		utility = { "^[db]ash$", "^sh$","^t?csh$","^zsh$" },
		ext = { "%.bash$", "%.csh$", "%.sh$", "%.zsh$" ,"^APKBUILD$", "%.ebuild$", "^.bashrc$", "^.bash_profile$" },
		mime = { "text/x-shellscript", "application/x-shellscript" },
	},
	batch = {
		ext = { "%.bat$", "%.cmd$" },
	},
	bibtex = {
		ext = { "%.bib$" },
	},
	boo = {
		ext = { "%.boo$" },
	},
	caml = {
		ext = { "%.caml$", "%.ml$", "%.mli$", "%.mll$", "%.mly$" },
	},
	chuck = {
		ext = { "%.ck$" },
	},
	clojure = {
		ext = { "%.clj$", "%.cljc$",  "%.cljs$", "%.edn$" }
	},
	cmake = {
		ext = { "%.cmake$", "%.cmake.in$", "%.ctest$", "%.ctest.in$" },
	},
	coffeescript = {
		ext = { "%.coffee$" },
		mime = { "text/x-coffee" },
	},
	cpp = {
		ext = { "%.cpp$", "%.cxx$", "%.c++$", "%.cc$", "%.hh$", "%.hpp$", "%.hxx$", "%.h++$" },
		mime = { "text/x-c++" },
	},
	crontab = {
		ext = { "^crontab.*$" },
		cmd = { "set savemethod inplace" },
	},
	crystal = {
		ext = { "%.cr$" },
	},
	csharp = {
		ext = { "%.cs$" },
	},
	css = {
		ext = { "%.css$" },
		mime = { "text/x-css" },
	},
	cuda = {
		ext = { "%.cu$", "%.cuh$" },
	},
	dart = {
		ext = { "%.dart$" },
	},
	desktop = {
		ext = { "%.desktop$" },
	},
	diff = {
		ext = { "%.diff$", "%.patch$", "%.rej$", "^COMMIT_EDITMSG$" },
		cmd = { "set colorcolumn 72" },
	},
	dmd = {
		ext = { "%.d$", "%.di$" },
	},
	dockerfile = {
		ext = { "^Dockerfile$", "%.Dockerfile$" },
	},
	dot = {
		ext = { "%.dot$" },
	},
	dsv = {
		ext = { "^group$", "^gshadow$", "^passwd$", "^shadow$" },
	},
	eiffel = {
		ext = { "%.e$", "%.eif$" },
	},
	elixir = {
		ext = { "%.ex$", "%.exs$" },
	},
	elm = {
		ext = { "%.elm$" },
	},
	erlang = {
		ext = { "%.erl$", "%.hrl$" },
	},
	fantom = {
		ext = { "%.fan$" },
	},
	faust = {
		ext = { "%.dsp$" },
	},
	fennel = {
		ext = { "%.fnl$" },
	},
	fish = {
		utility = { "^fish$" },
		ext = { "%.fish$" },
	},
	forth = {
		ext = { "%.forth$", "%.frt$", "%.fs$", "%.fth$" },
	},
	fortran = {
		ext = { "%.f$", "%.for$", "%.ftn$", "%.fpp$", "%.f77$", "%.f90$", "%.f95$", "%.f03$", "%.f08$" },
	},
	fsharp = {
		ext = { "%.fs$" },
	},
	fstab = {
		ext = { "fstab" },
	},
	gap = {
		ext = { "%.g$", "%.gd$", "%.gi$", "%.gap$" },
	},
	gemini = {
		ext = { "%.gmi" },
		mime = { "text/gemini" },
	},
	gettext = {
		ext = { "%.po$", "%.pot$" },
	},
	gherkin = {
		ext = { "%.feature$" },
	},
	['git-rebase'] = {
		ext = { "git%-rebase%-todo" },
	},
	glsl = {
		ext = { "%.glslf$", "%.glslv$" },
	},
	gnuplot = {
		ext = { "%.dem$", "%.plt$" },
	},
	go = {
		ext = { "%.go$" },
	},
	groovy = {
		ext = { "%.groovy$", "%.gvy$", "^Jenkinsfile$" },
	},
	gtkrc = {
		ext = { "%.gtkrc$" },
	},
	hare = {
		ext = { "%.ha$" }
	},
	haskell = {
		ext = { "%.hs$" },
		mime = { "text/x-haskell" },
	},
	html = {
		ext = { "%.htm$", "%.html$", "%.shtm$", "%.shtml$", "%.xhtml$" },
		mime = { "text/x-html" },
	},
	icon = {
		ext = { "%.icn$" },
	},
	idl = {
		ext = { "%.idl$", "%.odl$" },
	},
	inform = {
		ext = { "%.inf$", "%.ni$" },
	},
	ini = {
		ext = { "%.cfg$", "%.cnf$", "%.conf$", "%.inf$", "%.ini$", "%.reg$" },
	},
	io_lang = {
		ext = { "%.io$" },
	},
	java = {
		ext = { "%.bsh$", "%.java$" },
	},
	javascript = {
		ext = { "%.cjs$", "%.js$", "%.jsfl$", "%.mjs$", "%.ts$", "%.jsx$", "%.tsx$" },
	},
	json = {
		ext = { "%.json$" },
		mime = { "text/x-json" },
	},
	jsp = {
		ext = { "%.jsp$" },
	},
	julia = {
		ext = { "%.jl$" },
	},
	latex = {
		ext = { "%.bbl$", "%.cls$", "%.dtx$", "%.ins$", "%.ltx$", "%.tex$", "%.sty$" },
		mime = { "text/x-tex" },
	},
	ledger = {
		ext = { "%.ledger$", "%.journal$" },
	},
	less = {
		ext = { "%.less$" },
	},
	lilypond = {
		ext = { "%.ily$", "%.ly$" },
	},
	lisp = {
		ext = { "%.cl$", "%.el$", "%.lisp$", "%.lsp$" },
		mime = { "text/x-lisp" },
	},
	litcoffee = {
		ext = { "%.litcoffee$" },
	},
	logtalk = {
		ext = { "%.lgt$" },
	},
	lua = {
		utility = {"^lua%-?5?%d?$", "^lua%-?5%.%d$" },
		ext = { "%.lua$" },
		mime = { "text/x-lua" },
	},
	makefile = {
		hashbang = {"^#!/usr/bin/make"},
		utility = {"^make$"},
		ext = { "%.iface$", "%.mak$", "%.mk$", "GNUmakefile", "makefile", "Makefile" },
		mime = { "text/x-makefile" },
	},
	man = {
		ext = {
			"%.1$", "%.2$", "%.3$", "%.4$", "%.5$", "%.6$", "%.7$",
			"%.8$", "%.9$", "%.1x$", "%.2x$", "%.3x$", "%.4x$",
			"%.5x$", "%.6x$", "%.7x$", "%.8x$", "%.9x$"
		},
	},
	markdown = {
		ext = { "%.md$", "%.markdown$" },
		mime = { "text/x-markdown" },
	},
	meson = {
		ext = { "^meson%.build$" },
	},
	moonscript = {
		ext = { "%.moon$" },
		mime = { "text/x-moon" },
	},
	myrddin = {
		ext = { "%.myr$" },
	},
	nemerle = {
		ext = { "%.n$" },
	},
	networkd = {
		ext = { "%.link$", "%.network$", "%.netdev$" },
	},
	nim = {
		ext = { "%.nim$" },
	},
	nsis = {
		ext = { "%.nsh$", "%.nsi$", "%.nsis$" },
	},
	objective_c = {
		ext = { "%.m$", "%.mm$", "%.objc$" },
		mime = { "text/x-objc" },
	},
	pascal = {
		ext = { "%.dpk$", "%.dpr$", "%.p$", "%.pas$" },
	},
	perl = {
		ext = { "%.al$", "%.perl$", "%.pl$", "%.pm$", "%.pod$" },
		mime = { "text/x-perl" },
	},
	php = {
		ext = { "%.inc$", "%.php$", "%.php3$", "%.php4$", "%.phtml$" },
	},
	pico8 = {
		ext = { "%.p8$" },
	},
	pike = {
		ext = { "%.pike$", "%.pmod$" },
	},
	pkgbuild = {
		ext = { "^PKGBUILD$", "%.PKGBUILD$" },
	},
	pony = {
		ext = { "%.pony$" },
	},
	powershell = {
		ext = { "%.ps1$" },
	},
	prolog = {
		ext = { "%.pl$", "%.pro$", "%.prolog$" },
	},
	props = {
		ext = { "%.props$", "%.properties$" },
	},
	protobuf = {
		ext = { "%.proto$" },
	},
	ps = {
		ext = { "%.eps$", "%.ps$" },
	},
	pure = {
		ext = { "%.pure$" },
	},
	python = {
		utility = { "^python%d?" },
		ext = { "%.sc$", "%.py$", "%.pyw$" },
		mime = { "text/x-python", "text/x-script.python" },
	},
	reason = {
		ext = { "%.re$" },
	},
	rc = {
		utility = {"^rc$"},
		ext = { "%.rc$", "%.es$" },
	},
	rebol = {
		ext = { "%.r$", "%.reb$" },
	},
	rest = {
		ext = { "%.rst$" },
	},
	rexx = {
		ext = { "%.orx$", "%.rex$" },
	},
	rhtml = {
		ext = { "%.erb$", "%.rhtml$" },
	},
	routeros = {
		ext = { "%.rsc" },
		detect = function(_, data)
			return data:match("^#.* by RouterOS")
		end
	},
	rstats = {
		ext = { "%.R$", "%.Rout$", "%.Rhistory$", "%.Rt$", "Rout.save", "Rout.fail" },
	},
	ruby = {
		ext = { "%.Rakefile$", "%.rake$", "%.rb$", "%.rbw$", "^Vagrantfile$" },
		mime = { "text/x-ruby" },
	},
	rust = {
		ext = { "%.rs$" },
		mime = { "text/x-rust" },
	},
	sass = {
		ext = { "%.sass$", "%.scss$" },
		mime = { "text/x-sass", "text/x-scss" },
	},
	scala = {
		ext = { "%.scala$" },
		mime = { "text/x-scala" },
	},
	scheme = {
		ext = { "%.rkt$", "%.sch$", "%.scm$", "%.sld$", "%.sls$", "%.ss$" },
	},
	smalltalk = {
		ext = { "%.changes$", "%.st$", "%.sources$" },
	},
	sml = {
		ext = { "%.sml$", "%.fun$", "%.sig$" },
	},
	snobol4 = {
		ext = { "%.sno$", "%.SNO$" },
	},
	spin = {
		ext = { "%.spin$" }
	},
	sql= {
		ext = { "%.ddl$", "%.sql$" },
	},
	strace = {
		detect = function(_, data)
			return data:match("^execve%(")
		end
	},
	systemd = {
		ext = {
			"%.automount$", "%.device$", "%.mount$", "%.path$",
			"%.scope$", "%.service$", "%.slice$", "%.socket$",
			"%.swap$", "%.target$", "%.timer$"
		},
	},
	taskpaper = {
		ext = { "%.taskpaper$" },
	},
	tcl = {
		utility = {"^tclsh$", "^jimsh$" },
		ext = { "%.tcl$", "%.tk$" },
	},
	texinfo = {
		ext = { "%.texi$" },
	},
	text = {
		ext = { "%.txt$" },
		-- Do *not* list mime "text/plain" here, it is covered below,
		-- see 'try text lexer as a last resort'
	},
	toml = {
		ext = { "%.toml$" },
	},
	vala = {
		ext = { "%.vala$" }
	},
	vb = {
		ext = {
			"%.asa$", "%.bas$", "%.ctl$", "%.dob$",
			"%.dsm$", "%.dsr$", "%.frm$", "%.pag$", "%.vb$",
			"%.vba$", "%.vbs$"
		},
	},
	vcard = {
		ext = { "%.vcf$", "%.vcard$" },
	},
	verilog = {
		ext = { "%.v$", "%.ver$", "%.sv$" },
	},
	vhdl = {
		ext = { "%.vh$", "%.vhd$", "%.vhdl$" },
	},
	wsf = {
		ext = { "%.wsf$" },
	},
	xs = {
		ext = { "%.xs$", "^%.xsin$", "^%.xsrc$" },
	},
	xml = {
		ext = {
			"%.dtd$", "%.glif$", "%.plist$", "%.svg$", "%.xml$",
			"%.xsd$", "%.xsl$", "%.xslt$", "%.xul$"
		},
	},
	xtend = {
		ext = {"%.xtend$" },
	},
	yaml = {
		ext = { "%.yaml$", "%.yml$" },
		mime = { "text/x-yaml" },
	},
	zig = {
		ext = { "%.zig$" },
	},
}

ftdetect.lookup_lexer = function (filename)
	-- uhh
	for lang, ft in pairs(ftdetect.filetypes) do
		for _, pattern in pairs(ft.ext or {}) do
			if filename:match(pattern) then
				return lang;
			end
		end
	end
end

return ftdetect
