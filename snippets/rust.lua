---@diagnostic disable: undefined-global

return {
	s(
		{ trig = "dpl" },
		fmta([[println!("{:?}", <>)]], {
			i(1),
		})
	),
	s(
		{ trig = "p" },
		fmta([[println!("{}", <>)]], {
			i(1),
		})
	),
    -- funciton
    s("fn", {
      t("fn "), i(1, "name"), t("("), i(2, "params"), t(")"),
      c(3, { t(""), sn(nil, { t(" -> "), i(1, "ReturnType") }) }),
      t({" {", "\t"}), i(0), t({"", "}"})
    }),

    -- Impl block
    s("im", {
      t("impl "), i(1, "Type"),
      t({" {", "\t"}), i(0), t({"", "}"})
    }),

    -- Method
    s("md", {
      t("fn "), i(1, "method"),
      t("(&self"), i(2), t(")"),
      c(3, { t(""), sn(nil, { t(" -> "), i(1, "ReturnType") }) }),
      t({" {", "\t"}), i(0), t({"", "}"})
    }),

    -- Struct
    s("st", {
      t("struct "), i(1, "Name"), t({" {", "\t"}), i(0), t({"", "}"})
    }),

    -- Enum
    s("en", {
      t("enum "), i(1, "Name"), t({" {", "\t"}), i(0), t({"", "}"})
    }),

    -- Trait
    s("tr", {
      t("trait "), i(1, "Name"), t({" {", "\t"}), i(0), t({"", "}"})
    }),

    -- Test function
    s("ts", {
      t({"#[test]", "fn "}), i(1, "test_name"), t({"() {", "\t"}), i(0), t({"", "}"})
    }),
}
