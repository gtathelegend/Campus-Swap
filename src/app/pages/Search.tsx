import { useState } from "react";
import { useNavigate } from "react-router";
import { Search as SearchIcon, SlidersHorizontal, LayoutGrid } from "lucide-react";
import { C, font, shadow, products } from "../data";
import { BottomNav } from "../components/BottomNav";

export default function Search() {
  const navigate = useNavigate();
  const [query, setQuery] = useState("");
  const [focused, setFocused] = useState(false);

  const filtered = query
    ? products.filter(
        (p) =>
          p.name.toLowerCase().includes(query.toLowerCase()) ||
          p.category.toLowerCase().includes(query.toLowerCase())
      )
    : products;

  const isEmpty = filtered.length === 0;

  return (
    <div className="flex flex-col h-full" style={{ background: C.cream }}>
      {/* Search Header */}
      <div
        className="flex-shrink-0 flex flex-col gap-4 px-4 pt-4 pb-3"
        style={{ background: C.base, borderBottom: `1px solid ${C.border}` }}
      >
        <div
          className="flex items-center gap-3 rounded-2xl px-4"
          style={{
            background: C.cream,
            height: 48,
            border: focused ? `1.5px solid ${C.gold}` : `1px solid ${C.border}`,
            transition: "border 0.15s",
          }}
        >
          <SearchIcon size={20} color={C.mocha} strokeWidth={1.7} />
          <input
            type="text"
            placeholder="Textbooks..."
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            onFocus={() => setFocused(true)}
            onBlur={() => setFocused(false)}
            className="flex-1 outline-none bg-transparent"
            style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}
          />
        </div>

        <div className="flex items-center justify-between">
          <span style={{ fontFamily: font.family, fontSize: 16, color: C.mocha, letterSpacing: "-0.3125px" }}>
            {filtered.length} results
          </span>
          <div className="flex gap-2">
            <button
              onClick={() => navigate("/filters")}
              className="flex items-center justify-center rounded-[10px]"
              style={{ width: 38, height: 38, border: `1px solid ${C.border}` }}
            >
              <SlidersHorizontal size={18} color={C.espresso} strokeWidth={1.7} />
            </button>
            <button
              className="flex items-center justify-center rounded-[10px]"
              style={{ width: 38, height: 38, border: `1px solid ${C.border}` }}
            >
              <LayoutGrid size={18} color={C.espresso} strokeWidth={1.7} />
            </button>
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="flex-1 overflow-y-auto">
        {isEmpty ? (
          /* Empty state */
          <div className="flex flex-col items-center justify-center gap-4 px-6 pt-24">
            <div
              className="flex items-center justify-center rounded-full"
              style={{ width: 96, height: 96, background: C.border }}
            >
              <SearchIcon size={40} color={C.mocha} strokeWidth={1.5} />
            </div>
            <div className="flex flex-col items-center gap-2">
              <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
                No Items Found
              </span>
              <span style={{ fontFamily: font.family, fontSize: 16, color: C.mocha, letterSpacing: "-0.3125px", textAlign: "center" }}>
                Try adjusting your search or filters
              </span>
            </div>
            <button
              onClick={() => setQuery("")}
              className="flex items-center justify-center rounded-2xl"
              style={{ background: C.gold, height: 48, paddingLeft: 24, paddingRight: 24, boxShadow: shadow.button }}
            >
              <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
                Clear Filters
              </span>
            </button>
          </div>
        ) : (
          <div className="grid grid-cols-2 gap-3 p-4">
            {filtered.map((product) => (
              <button
                key={product.id}
                onClick={() => navigate(`/product/${product.id}`)}
                className="flex flex-col rounded-[20px] overflow-hidden text-left"
                style={{ background: C.base, border: `1px solid ${C.border}`, boxShadow: shadow.card }}
              >
                <div className="relative w-full" style={{ height: 128 }}>
                  <img src={product.image} alt={product.name} className="w-full h-full object-cover" />
                  {(product.condition === "New" || product.condition === "Good") && (
                    <div
                      className="absolute top-2 right-2 flex items-center justify-center rounded-full px-2"
                      style={{ background: C.gold, height: 32 }}
                    >
                      <span style={{ fontFamily: font.family, fontSize: 10, color: C.espresso }}>{product.condition}</span>
                    </div>
                  )}
                </div>
                <div className="flex flex-col gap-1 p-3">
                  <span style={{ fontFamily: font.family, fontSize: 14, color: C.espresso, letterSpacing: "-0.3125px" }}>{product.name}</span>
                  <span style={{ fontFamily: font.family, fontSize: 14, color: C.espresso, letterSpacing: "-0.3125px" }}>{product.currency}{product.price}</span>
                </div>
              </button>
            ))}
          </div>
        )}
      </div>

      <BottomNav active="search" />
    </div>
  );
}
