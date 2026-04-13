import { useState } from "react";
import { useNavigate } from "react-router";
import { Camera, ChevronDown } from "lucide-react";
import { C, font, shadow } from "../data";
import { BottomNav } from "../components/BottomNav";

const conditions = ["New", "Like New", "Good", "Fair"];
const categoryList = ["Books", "Tech", "Fashion", "Bikes", "Furniture", "Other"];

export default function Sell() {
  const navigate = useNavigate();
  const [title, setTitle] = useState("");
  const [desc, setDesc] = useState("");
  const [price, setPrice] = useState("");
  const [condition, setCondition] = useState("");
  const [category, setCategory] = useState("");
  const [submitted, setSubmitted] = useState(false);

  const handlePost = () => {
    if (!title || !price) return;
    setSubmitted(true);
    setTimeout(() => navigate("/"), 1500);
  };

  if (submitted) {
    return (
      <div className="flex flex-col items-center justify-center gap-4 h-full px-6 text-center" style={{ background: C.cream }}>
        <div
          className="flex items-center justify-center rounded-full"
          style={{ width: 72, height: 72, background: `${C.gold}33`, border: `2px solid ${C.gold}` }}
        >
          <span style={{ fontSize: 32 }}>✓</span>
        </div>
        <p style={{ fontFamily: font.family, fontSize: 18, fontWeight: 500, color: C.espresso }}>Item Listed!</p>
        <p style={{ fontFamily: font.family, fontSize: 16, color: C.mocha }}>Your listing is now live.</p>
      </div>
    );
  }

  return (
    <div className="flex flex-col h-full" style={{ background: C.cream }}>
      {/* Header */}
      <div
        className="flex-shrink-0 flex items-center px-4"
        style={{ background: C.base, height: 63, borderBottom: `1px solid ${C.border}` }}
      >
        <span style={{ fontFamily: font.family, fontSize: 20, fontWeight: 500, color: C.espresso, letterSpacing: "-0.449px" }}>
          Post New Item
        </span>
      </div>

      <div className="flex-1 overflow-y-auto p-4 flex flex-col gap-4">
        {/* Photo upload */}
        <button
          className="w-full flex flex-col items-center justify-center gap-2 rounded-3xl"
          style={{ height: 160, background: C.base, border: `2px dashed ${C.border}` }}
        >
          <Camera size={40} color={C.mocha} strokeWidth={1.6} />
          <span style={{ fontFamily: font.family, fontSize: 16, color: C.mocha, letterSpacing: "-0.3125px" }}>
            Add Photos
          </span>
          <span style={{ fontFamily: font.family, fontSize: 13, color: C.stone }}>
            Up to 5 photos
          </span>
        </button>

        {/* Title */}
        <div className="flex flex-col gap-2">
          <span style={{ fontFamily: font.family, fontSize: 16, color: C.mocha, letterSpacing: "-0.3125px" }}>Item Name</span>
          <input
            type="text" placeholder="Enter item name..."
            value={title} onChange={(e) => setTitle(e.target.value)}
            className="rounded-[14px] px-4 outline-none"
            style={{ height: 50, background: C.base, border: `1px solid ${C.border}`, boxShadow: shadow.input, fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}
          />
        </div>

        {/* Description */}
        <div className="flex flex-col gap-2">
          <span style={{ fontFamily: font.family, fontSize: 16, color: C.mocha, letterSpacing: "-0.3125px" }}>Description</span>
          <textarea
            placeholder="Describe your item..."
            value={desc} onChange={(e) => setDesc(e.target.value)}
            rows={4}
            className="rounded-[14px] px-4 py-3 outline-none resize-none"
            style={{ background: C.base, border: `1px solid ${C.border}`, boxShadow: shadow.input, fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}
          />
        </div>

        {/* Price */}
        <div className="flex flex-col gap-2">
          <span style={{ fontFamily: font.family, fontSize: 16, color: C.mocha, letterSpacing: "-0.3125px" }}>Price (₹)</span>
          <input
            type="number" placeholder="0"
            value={price} onChange={(e) => setPrice(e.target.value)}
            className="rounded-[14px] px-4 outline-none"
            style={{ height: 50, background: C.base, border: `1px solid ${C.border}`, boxShadow: shadow.input, fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}
          />
        </div>

        {/* Condition */}
        <div className="flex flex-col gap-2">
          <span style={{ fontFamily: font.family, fontSize: 16, color: C.mocha, letterSpacing: "-0.3125px" }}>Condition</span>
          <div className="flex gap-2 flex-wrap">
            {conditions.map((c) => (
              <button
                key={c}
                onClick={() => setCondition(c)}
                className="flex items-center justify-center rounded-full px-4"
                style={{ height: 38, background: condition === c ? C.gold : C.base, border: `1px solid ${condition === c ? C.gold : C.border}` }}
              >
                <span style={{ fontFamily: font.family, fontSize: 14, color: C.espresso }}>{c}</span>
              </button>
            ))}
          </div>
        </div>

        {/* Category */}
        <div className="flex flex-col gap-2">
          <span style={{ fontFamily: font.family, fontSize: 16, color: C.mocha, letterSpacing: "-0.3125px" }}>Category</span>
          <div className="relative">
            <select
              value={category} onChange={(e) => setCategory(e.target.value)}
              className="w-full appearance-none rounded-[14px] px-4 outline-none"
              style={{ height: 50, background: C.base, border: `1px solid ${C.border}`, boxShadow: shadow.input, fontFamily: font.family, fontSize: 16, color: category ? C.espresso : C.stone, letterSpacing: "-0.3125px" }}
            >
              <option value="" disabled>Select category</option>
              {categoryList.map((c) => <option key={c} value={c}>{c}</option>)}
            </select>
            <ChevronDown size={18} color={C.mocha} className="absolute right-4 top-1/2 -translate-y-1/2 pointer-events-none" />
          </div>
        </div>
      </div>

      {/* Post button */}
      <div className="flex-shrink-0 px-4 pt-4 pb-5" style={{ background: C.base, borderTop: `1px solid ${C.border}` }}>
        <button
          onClick={handlePost}
          className="w-full flex items-center justify-center rounded-2xl"
          style={{ background: title && price ? C.gold : C.border, height: 48, boxShadow: title && price ? shadow.button : "none", transition: "background 0.2s" }}
        >
          <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
            Post Item
          </span>
        </button>
      </div>

      <BottomNav active="sell" />
    </div>
  );
}
