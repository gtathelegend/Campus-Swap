import { useNavigate } from "react-router";
import { Search, BookOpen, Laptop, ShoppingBag, Bike, Sofa, User } from "lucide-react";
import { C, font, shadow, products, categories } from "../data";
import { BottomNav } from "../components/BottomNav";

const categoryIcons: Record<string, React.FC<{ size: number }>> = {
  books:     ({ size }) => <BookOpen   size={size} color={C.base}   strokeWidth={1.6} />,
  tech:      ({ size }) => <Laptop     size={size} color={C.base}   strokeWidth={1.6} />,
  fashion:   ({ size }) => <ShoppingBag size={size} color={C.base}  strokeWidth={1.6} />,
  bikes:     ({ size }) => <Bike       size={size} color={C.base}   strokeWidth={1.6} />,
  furniture: ({ size }) => <Sofa       size={size} color={C.base}   strokeWidth={1.6} />,
};

function ConditionBadge({ label }: { label: string }) {
  return (
    <div
      className="absolute top-2 right-2 flex items-center justify-center rounded-full px-2"
      style={{ background: C.gold, height: 32 }}
    >
      <span style={{ fontFamily: font.family, fontSize: 10, color: C.espresso, letterSpacing: "0.117px" }}>
        {label}
      </span>
    </div>
  );
}

export default function Home() {
  const navigate = useNavigate();
  const featured = products.slice(0, 4);

  return (
    <div className="flex flex-col h-full" style={{ background: C.cream }}>
      {/* Top bar */}
      <div className="flex-shrink-0 flex items-center justify-between px-4" style={{ background: C.base, height: 73, borderBottom: `1px solid ${C.border}` }}>
        <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
          Campus Swap
        </span>
        <button
          onClick={() => navigate("/profile")}
          className="flex items-center justify-center rounded-full"
          style={{ width: 40, height: 40, background: C.cream }}
        >
          <User size={20} color={C.espresso} strokeWidth={1.7} />
        </button>
      </div>

      {/* Scrollable content */}
      <div className="flex-1 overflow-y-auto">
        {/* Search bar */}
        <div className="px-4 pt-4 pb-2">
          <button
            onClick={() => navigate("/search")}
            className="w-full flex items-center gap-3 rounded-2xl px-4"
            style={{ background: C.cream, height: 48, border: `1px solid ${C.border}` }}
          >
            <Search size={20} color={C.mocha} strokeWidth={1.7} />
            <span style={{ fontFamily: font.family, fontSize: 16, color: C.stone, letterSpacing: "-0.3125px" }}>
              Search for items...
            </span>
          </button>
        </div>

        {/* Categories */}
        <div className="flex gap-4 px-4 py-4 overflow-x-auto" style={{ scrollbarWidth: "none" }}>
          {categories.map((cat) => {
            const Icon = categoryIcons[cat.id];
            return (
              <button
                key={cat.id}
                onClick={() => navigate(`/category/${cat.id}`)}
                className="flex flex-col items-center gap-2 flex-shrink-0"
              >
                <div
                  className="flex items-center justify-center rounded-full"
                  style={{ width: 56, height: 56, background: C.espresso }}
                >
                  <Icon size={24} />
                </div>
                <span style={{ fontFamily: font.family, fontSize: 12, color: C.espresso, letterSpacing: "-0.3125px" }}>
                  {cat.name}
                </span>
              </button>
            );
          })}
        </div>

        {/* Recently Listed header */}
        <div className="flex items-center justify-between px-4 pb-3">
          <span style={{ fontFamily: font.family, fontSize: 20, fontWeight: 700, color: C.espresso, letterSpacing: "-0.449px" }}>
            Recently Listed
          </span>
          <button onClick={() => navigate("/search")}>
            <span style={{ fontFamily: font.family, fontSize: 16, color: C.mocha, letterSpacing: "-0.3125px" }}>
              View All
            </span>
          </button>
        </div>

        {/* Product grid */}
        <div className="grid grid-cols-2 gap-3 px-4 pb-4">
          {featured.map((product) => (
            <button
              key={product.id}
              onClick={() => navigate(`/product/${product.id}`)}
              className="flex flex-col rounded-[20px] overflow-hidden text-left"
              style={{ background: C.base, border: `1px solid ${C.border}`, boxShadow: shadow.card }}
            >
              {/* Image */}
              <div className="relative w-full" style={{ height: 140 }}>
                <img
                  src={product.image}
                  alt={product.name}
                  className="w-full h-full object-cover"
                />
                {product.condition !== "Like New" && product.condition !== "New" && (
                  <ConditionBadge label={product.condition} />
                )}
                {product.condition === "New" && <ConditionBadge label="New" />}
              </div>
              {/* Info */}
              <div className="flex flex-col gap-1 p-3">
                <span style={{ fontFamily: font.family, fontSize: 14, color: C.espresso, letterSpacing: "-0.3125px" }}>
                  {product.name}
                </span>
                <span style={{ fontFamily: font.family, fontSize: 14, color: C.espresso, letterSpacing: "-0.3125px" }}>
                  {product.currency}{product.price}
                </span>
              </div>
            </button>
          ))}
        </div>
      </div>

      <BottomNav active="home" />
    </div>
  );
}
