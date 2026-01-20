local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- ∀∃□¬∨∧∑λ∈∅

--[[local function get_date()
	return os.date("%m-%d-%Y")
end]]

return {
    -- latex
    s("pagebreak", t("\\pagebreak")),

	-- math plain text snippets
	s("lam", t("λ")),
	s("lsm", t("∃")),
	s("lal", t("∀")),
	s("land", t("∧")),
	s("lor", t("∨")),
	s("lnot", t("¬")),
	s("lin", t("∈")),
	s("nil", t("∅")),
	s("summ", t("∑")),

    -- more math
    s("polynomial", t("$A(x) = a_0 + a_{1}x + a_{2}x^{2}$")),
    s("power", t("$^{}$")),
    s("powernested", t("$^{^{}}$")),
    s("square", t("$\\sqrt{}$")),
    s("root", t("$\\sqrt[]{}$")),
    s("coef", t("$_{}$")),
    s("coefseries", t("{$x_1, x_2, x_3, x_4, x_5$}")),
    s("fraction", t("$\\frac{}{}$")),
    s("multiply", t("$ \\cdot $")),

	-- gen words
	s("bec", t("because")),
	s("there", t("therefore")),
	s("uni", t("university")),
    s("org", t("organization")),
	s("cs", t("computer Science")),
	s("pe", t("people")),
	s("per", t("person")),
	s("dif", t("different")),

    -- writing
    s("indent", t("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")),

    -- misc
	s("head", {
        t({"---"}),
		t({"", "author: "}),
        i(1, "Alexander Hays"),
		t({"", "title: "}),
		i(1, "add title here"),
        t({"", "subtitle: " }),
        i(1, "add subtitle here"),
        t({"", "date: " }),
        i(1, "\\today"),
        t({"", "---"}),
	}),
    s("rightarrow", t("\\rightarrow")),
    s("leftarrow", t("\\leftarrow")),

	-- todo functionality
	s("td", t("- [ ]")),
	s("td", t("- [x]")),
}
