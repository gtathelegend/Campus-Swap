import { useNavigate, useParams } from "react-router";
import { ChevronLeft } from "lucide-react";
import { C, font, shadow, products, electronicsProducts } from "../data";
import { BottomNav } from "../components/BottomNav";

export default function Category() {
  const navigate = useNavigate();
  const { name } = useParams<{ name: string }>();

  const categoryName = name
    ? name.charAt(0).toUpperCase() + name.slice(1)
    : "Category";

  // Use electronics-specific data if tech/electronics, else filter from products
  const isTech = name === "tech";
  const regularItems = products.filter((p) => p.category.toLowerCase() === name?.toLowerCase());

  return (
    <div className="flex flex-col h-full" style={{ background: C.cream }}>
      {/* Header */}
      <div
        className="flex-shrink-0 flex items-center gap-3 px-4"
        style={{ background: C.base, height: 57, borderBottom: `1px solid ${C.border}` }}
      >
        <button onClick={() => navigate(-1)}>
          <ChevronLeft size={24} color={C.espresso} strokeWidth={2} />
        </button>
        <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
          {categoryName === "Tech" ? "Electronics" : categoryName}
        </span>
      </div>

      {/* Products grid */}
      <div className="flex-1 overflow-y-auto p-4">
        {isTech ? (
          // Electronics layout — beige placeholder images (as in Figma)
          <div className="grid grid-cols-2 gap-3">
            {electronicsProducts.map((item) => {
              const hasBadge = item.condition === "New" || item.condition === "Good";
              return (
                <button
                  key={item.id}
                  onClick={() => navigate(`/product/${item.id}`)}
                  className="flex flex-col rounded-[20px] overflow-hidden text-left"
                  style={{ background: C.base, border: `1px solid ${C.border}`, boxShadow: shadow.card }}
                >
                  {/* Placeholder image (beige) */}
                  <div className="relative w-full flex items-center justify-center" style={{ height: 128, background: C.border }}>
                    {hasBadge && (
                      <div
                        className="absolute top-2 right-2 flex items-center justify-center rounded-full px-2"
                        style={{ background: C.gold, height: 32 }}
                      >
                        <span style={{ fontFamily: font.family, fontSize: 10, color: C.espresso }}>
                          {item.condition}
                        </span>
                      </div>
                    )}
                  </div>
                  <div className="flex flex-col gap-1 p-3">
                    <span style={{ fontFamily: font.family, fontSize: 14, color: C.espresso, letterSpacing: "-0.3125px" }}>{item.name}</span>
                    <span style={{ fontFamily: font.family, fontSize: 14, color: C.espresso, letterSpacing: "-0.3125px" }}>{item.currency}{item.price}</span>
                  </div>
                </button>
              );
            })}
          </div>
        ) : regularItems.length > 0 ? (
          <div className="grid grid-cols-2 gap-3">
            {regularItems.map((product) => (
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
        ) : (
          <div className="flex flex-col items-center justify-center gap-3 pt-20">
            <p style={{ fontFamily: font.family, fontSize: 16, color: C.mocha }}>No items in this category yet.</p>
          </div>
        )}
      </div>

      <BottomNav active="search" />
    </div>
  );
}
