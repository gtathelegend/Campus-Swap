import { useState } from "react";
import { useNavigate } from "react-router";
import { C, font, shadow } from "../data";

const categoryOptions = ["Books", "Electronics", "Fashion", "Bikes", "Furniture"];
const conditionOptions = ["New", "Like New", "Good", "Fair"];

export default function Filters() {
  const navigate = useNavigate();
  const [activeCategory, setActiveCategory] = useState("Books");
  const [priceMax, setPriceMax] = useState(70);
  const [conditions, setConditions] = useState<Set<string>>(new Set());

  const toggleCondition = (c: string) => {
    const next = new Set(conditions);
    next.has(c) ? next.delete(c) : next.add(c);
    setConditions(next);
  };

  const reset = () => {
    setActiveCategory("Books");
    setPriceMax(70);
    setConditions(new Set());
  };

  return (
    <div className="flex flex-col h-full" style={{ background: C.cream }}>
      {/* Header */}
      <div
        className="flex-shrink-0 flex items-center justify-between px-4"
        style={{ background: C.base, height: 63, borderBottom: `1px solid ${C.border}` }}
      >
        <span style={{ fontFamily: font.family, fontSize: 20, fontWeight: 500, color: C.espresso, letterSpacing: "-0.449px" }}>
          Filters
        </span>
        <button onClick={reset}>
          <span style={{ fontFamily: font.family, fontSize: 16, color: C.mocha, letterSpacing: "-0.3125px" }}>
            Reset
          </span>
        </button>
      </div>

      {/* Content */}
      <div className="flex-1 overflow-y-auto p-4 flex flex-col gap-6">
        {/* Category */}
        <div className="flex flex-col gap-3">
          <span style={{ fontFamily: font.family, fontSize: 18, fontWeight: 500, color: C.espresso, letterSpacing: "-0.44px" }}>
            Category
          </span>
          <div className="flex flex-wrap gap-2">
            {categoryOptions.map((cat) => {
              const isActive = cat === activeCategory;
              return (
                <button
                  key={cat}
                  onClick={() => setActiveCategory(cat)}
                  className="flex items-center justify-center rounded-full px-4"
                  style={{
                    height: 42,
                    background: isActive ? C.gold : C.base,
                    border: `1px solid ${isActive ? C.gold : C.border}`,
                  }}
                >
                  <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
                    {cat}
                  </span>
                </button>
              );
            })}
          </div>
        </div>

        {/* Price Range */}
        <div className="flex flex-col gap-3">
          <span style={{ fontFamily: font.family, fontSize: 18, fontWeight: 500, color: C.espresso, letterSpacing: "-0.44px" }}>
            Price Range
          </span>
          {/* Slider */}
          <div className="relative w-full" style={{ height: 8 }}>
            <div className="w-full h-full rounded-full" style={{ background: C.border }} />
            <div
              className="absolute top-0 left-0 h-full rounded-full"
              style={{ width: `${priceMax}%`, background: C.gold }}
            />
            <input
              type="range"
              min={0}
              max={100}
              value={priceMax}
              onChange={(e) => setPriceMax(Number(e.target.value))}
              className="absolute inset-0 w-full opacity-0 cursor-pointer"
              style={{ height: 8 }}
            />
          </div>
          <div className="flex justify-between">
            <span style={{ fontFamily: font.family, fontSize: 16, color: C.mocha, letterSpacing: "-0.3125px" }}>$0</span>
            <span style={{ fontFamily: font.family, fontSize: 16, color: C.mocha, letterSpacing: "-0.3125px" }}>${priceMax}</span>
          </div>
        </div>

        {/* Condition */}
        <div className="flex flex-col gap-3">
          <span style={{ fontFamily: font.family, fontSize: 18, fontWeight: 500, color: C.espresso, letterSpacing: "-0.44px" }}>
            Condition
          </span>
          <div className="flex flex-col gap-2">
            {conditionOptions.map((cond) => {
              const isChecked = conditions.has(cond);
              return (
                <button
                  key={cond}
                  onClick={() => toggleCondition(cond)}
                  className="flex items-center gap-3 rounded-2xl px-4"
                  style={{ background: C.base, height: 50, border: `1px solid ${C.border}`, boxShadow: shadow.card }}
                >
                  <div
                    className="flex items-center justify-center rounded"
                    style={{
                      width: 20, height: 20, flexShrink: 0,
                      border: isChecked ? `2px solid ${C.gold}` : `2px solid ${C.mocha}`,
                      background: isChecked ? C.gold : "transparent",
                    }}
                  >
                    {isChecked && (
                      <svg width="12" height="9" viewBox="0 0 12 9" fill="none">
                        <path d="M1 4L4.5 7.5L11 1" stroke={C.espresso} strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
                      </svg>
                    )}
                  </div>
                  <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
                    {cond}
                  </span>
                </button>
              );
            })}
          </div>
        </div>
      </div>

      {/* Apply button */}
      <div
        className="flex-shrink-0 flex flex-col px-4 pt-4 pb-5"
        style={{ background: C.base, borderTop: `1px solid ${C.border}` }}
      >
        <button
          onClick={() => navigate("/search")}
          className="w-full flex items-center justify-center rounded-2xl"
          style={{ background: C.gold, height: 48, boxShadow: shadow.button }}
        >
          <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
            Apply Filters
          </span>
        </button>
      </div>
    </div>
  );
}
