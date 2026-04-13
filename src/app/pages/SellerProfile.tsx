import { useNavigate, useParams } from "react-router";
import { ChevronLeft, Star } from "lucide-react";
import { C, font, shadow, sellers, sellerProducts } from "../data";
import { BottomNav } from "../components/BottomNav";

export default function SellerProfile() {
  const navigate = useNavigate();
  const { id } = useParams<{ id: string }>();

  const seller = sellers.find((s) => s.id === id) ?? sellers[0];
  const listings = sellerProducts(seller.id);

  // Supplement with seller-specific items if few real products
  const displayItems = listings.length >= 2 ? listings.slice(0, 4) : [
    { id: "seller-lamp",  name: "Desk Lamp",    price: 15, currency: "$", condition: "Good" as const, image: "" },
    { id: "seller-coat",  name: "Winter Coat",  price: 40, currency: "$", condition: "Good" as const, image: "" },
    { id: "notebook-set", name: "Notebook Set", price: 8,  currency: "$", condition: "New"  as const, image: "" },
    { id: "calculator",   name: "Calculator",   price: 20, currency: "$", condition: "New"  as const, image: "" },
  ];

  return (
    <div className="flex flex-col h-full" style={{ background: C.cream }}>
      {/* Header */}
      <div
        className="flex-shrink-0 flex items-center gap-3 px-4"
        style={{ background: C.base, height: 57, borderBottom: `1px solid ${C.border}`, position: "relative" }}
      >
        <button onClick={() => navigate(-1)}>
          <ChevronLeft size={24} color={C.espresso} strokeWidth={2} />
        </button>
        <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
          Seller Profile
        </span>
        <button
          onClick={() => navigate("/report/user")}
          className="absolute right-4"
        >
          <span style={{ fontFamily: font.family, fontSize: 13, color: C.gold, fontWeight: 500 }}>
            Report User
          </span>
        </button>
      </div>

      <div className="flex-1 overflow-y-auto">
        {/* Profile card */}
        <div
          className="flex flex-col items-center pb-5 pt-6 gap-3"
          style={{ background: C.base, borderBottom: `1px solid ${C.border}` }}
        >
          {/* Avatar */}
          <div className="rounded-full" style={{ width: 96, height: 96, background: C.border }} />

          {/* Name */}
          <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
            {seller.name}
          </span>

          {/* Rating */}
          <div className="flex items-center gap-1">
            <Star size={16} color={C.gold} fill={C.gold} />
            <span style={{ fontFamily: font.family, fontSize: 16, color: C.mocha, letterSpacing: "-0.3125px" }}>
              {seller.rating} ({seller.reviews} reviews)
            </span>
          </div>

          {/* Verified badge */}
          {seller.verified && (
            <div
              className="flex items-center justify-center rounded-full px-4"
              style={{ background: `${C.gold}22`, height: 32 }}
            >
              <span style={{ fontFamily: font.family, fontSize: 16, color: C.gold, letterSpacing: "-0.3125px" }}>
                Verified Student
              </span>
            </div>
          )}
        </div>

        {/* Stats */}
        <div
          className="flex items-center"
          style={{ background: C.base, height: 85, borderBottom: `1px solid ${C.border}` }}
        >
          {[
            { value: seller.listings, label: "Listings" },
            { value: seller.sold,     label: "Sold" },
            { value: seller.reviews,  label: "Reviews" },
          ].map((stat, i) => (
            <div
              key={stat.label}
              className="flex-1 flex flex-col items-center gap-1"
              style={{ borderLeft: i > 0 ? `1px solid ${C.border}` : "none" }}
            >
              <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
                {stat.value}
              </span>
              <span style={{ fontFamily: font.family, fontSize: 16, color: C.mocha, letterSpacing: "-0.3125px" }}>
                {stat.label}
              </span>
            </div>
          ))}
        </div>

        {/* Active listings */}
        <div className="p-4 flex flex-col gap-4">
          <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
            Active Listings
          </span>

          <div className="grid grid-cols-2 gap-3">
            {displayItems.map((item) => {
              const hasBadge = item.condition === "New" || item.condition === "Good";
              return (
                <button
                  key={item.id}
                  onClick={() => navigate(`/product/${item.id}`)}
                  className="flex flex-col rounded-[20px] overflow-hidden text-left"
                  style={{ background: C.base, border: `1px solid ${C.border}`, boxShadow: shadow.card }}
                >
                  <div
                    className="relative w-full flex items-center justify-center"
                    style={{ height: 128, background: C.border }}
                  >
                    {item.image ? (
                      <img src={item.image} alt={item.name} className="w-full h-full object-cover" />
                    ) : (
                      <div
                        className="rounded-[14px]"
                        style={{ width: 64, height: 64, background: "#C4B5A0" }}
                      />
                    )}
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
        </div>
      </div>

      <BottomNav active="home" />
    </div>
  );
}
