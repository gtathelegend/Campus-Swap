import { useState } from "react";
import { useNavigate, useParams } from "react-router";
import { ChevronLeft, Heart, MapPin, Star, ChevronRight } from "lucide-react";
import { C, font, shadow, products } from "../data";

// Fallback product for unknown IDs
const fallback = products[0];

export default function ProductDetail() {
  const navigate = useNavigate();
  const { id } = useParams<{ id: string }>();
  const [saved, setSaved] = useState(false);

  const product = products.find((p) => p.id === id) ?? fallback;
  const seller = product.seller;

  return (
    <div className="flex flex-col h-full" style={{ background: C.cream }}>
      {/* Header */}
      <div
        className="flex-shrink-0 flex items-center justify-between px-4"
        style={{ background: C.base, height: 57, borderBottom: `1px solid ${C.border}` }}
      >
        <button onClick={() => navigate(-1)}>
          <ChevronLeft size={24} color={C.espresso} strokeWidth={2} />
        </button>
        <button onClick={() => setSaved((s) => !s)}>
          <Heart
            size={24}
            color={saved ? C.gold : C.espresso}
            fill={saved ? C.gold : "none"}
            strokeWidth={2}
          />
        </button>
      </div>

      {/* Scrollable content */}
      <div className="flex-1 overflow-y-auto">
        {/* Product image */}
        <div
          className="w-full flex items-center justify-center"
          style={{ height: 256, background: C.border }}
        >
          <img
            src={product.image}
            alt={product.name}
            className="w-full h-full object-cover"
          />
        </div>

        {/* Details */}
        <div className="flex flex-col gap-4 p-4">
          {/* Title + price + badge */}
          <div className="relative" style={{ minHeight: 114 }}>
            <span
              className="block"
              style={{ fontFamily: font.family, fontSize: 24, fontWeight: 500, color: C.espresso, letterSpacing: "0.07px" }}
            >
              {product.name}
            </span>
            <span
              className="block mt-2"
              style={{ fontFamily: font.family, fontSize: 20, fontWeight: 500, color: C.gold, letterSpacing: "-0.449px" }}
            >
              {product.currency}{product.price}
            </span>
            <div
              className="inline-flex items-center rounded-full px-3 mt-3"
              style={{ background: `${C.gold}22`, height: 32 }}
            >
              <span style={{ fontFamily: font.family, fontSize: 16, color: C.gold, letterSpacing: "-0.3125px" }}>
                {product.condition}
              </span>
            </div>
          </div>

          {/* Divider */}
          <div style={{ height: 1, background: C.border }} />

          {/* Description */}
          <div className="flex flex-col gap-2">
            <span style={{ fontFamily: font.family, fontSize: 18, fontWeight: 500, color: C.espresso, letterSpacing: "-0.44px" }}>
              Description
            </span>
            <p style={{ fontFamily: font.family, fontSize: 16, color: C.mocha, lineHeight: "24px", letterSpacing: "-0.3125px" }}>
              {product.description}
            </p>
          </div>

          {/* Location */}
          <div className="flex items-center gap-2">
            <MapPin size={20} color={C.mocha} strokeWidth={1.7} />
            <span style={{ fontFamily: font.family, fontSize: 16, color: C.mocha, letterSpacing: "-0.3125px" }}>
              {product.location}
            </span>
          </div>

          {/* Seller card */}
          <button
            onClick={() => navigate(`/seller/${seller.id}`)}
            className="flex items-center gap-3 rounded-2xl px-4"
            style={{ background: C.base, height: 82, border: `1px solid ${C.border}`, boxShadow: shadow.card }}
          >
            <div className="rounded-full flex-shrink-0" style={{ width: 48, height: 48, background: C.border }} />
            <div className="flex-1 flex flex-col items-start gap-1">
              <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
                {seller.name}
              </span>
              <div className="flex items-center gap-1">
                <Star size={16} color={C.gold} fill={C.gold} />
                <span style={{ fontFamily: font.family, fontSize: 16, color: C.mocha, letterSpacing: "-0.3125px" }}>
                  {seller.rating} ({seller.reviews} reviews)
                </span>
              </div>
            </div>
            <ChevronRight size={20} color={C.mocha} strokeWidth={1.7} />
          </button>

          {/* Report listing */}
          <button onClick={() => navigate(`/report/${product.id}`)}>
            <span
              className="block text-center"
              style={{ fontFamily: font.family, fontSize: 16, color: C.alert, letterSpacing: "-0.3125px" }}
            >
              Report this listing
            </span>
          </button>
        </div>
      </div>

      {/* Bottom action bar */}
      <div
        className="flex-shrink-0 flex gap-3 px-4 pt-4 pb-5"
        style={{ background: C.base, borderTop: `1px solid ${C.border}` }}
      >
        {/* Save button */}
        <button
          onClick={() => setSaved((s) => !s)}
          className="flex items-center justify-center rounded-2xl"
          style={{
            background: C.base, height: 52, width: 90,
            border: `2px solid ${C.mocha}`,
            boxShadow: shadow.card,
          }}
        >
          <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
            Save
          </span>
        </button>

        {/* Chat with seller */}
        <button
          onClick={() => navigate(`/chat/${seller.id}`)}
          className="flex-1 flex items-center justify-center rounded-2xl"
          style={{ background: C.gold, height: 52, boxShadow: shadow.button }}
        >
          <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
            Chat with Seller
          </span>
        </button>
      </div>
    </div>
  );
}
