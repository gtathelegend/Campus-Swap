import { useState } from "react";
import { useNavigate } from "react-router";
import { ChevronLeft, AlertCircle } from "lucide-react";
import { C, font, shadow } from "../data";

const reportOptions = [
  "Inappropriate content",
  "Spam or misleading",
  "Prohibited item",
  "Fake listing",
  "Price manipulation",
  "Other",
];

export default function ReportListing() {
  const navigate = useNavigate();
  const [selected, setSelected] = useState<string | null>(null);
  const [details, setDetails] = useState("");
  const [submitted, setSubmitted] = useState(false);

  const handleSubmit = () => {
    if (!selected) return;
    setSubmitted(true);
    setTimeout(() => navigate(-1), 1500);
  };

  if (submitted) {
    return (
      <div className="flex flex-col items-center justify-center gap-4 h-full px-6 text-center" style={{ background: C.cream }}>
        <div
          className="flex items-center justify-center rounded-full"
          style={{ width: 72, height: 72, background: `${C.alert}22`, border: `2px solid ${C.alert}` }}
        >
          <AlertCircle size={36} color={C.alert} />
        </div>
        <p style={{ fontFamily: font.family, fontSize: 18, fontWeight: 500, color: C.espresso }}>Report Submitted</p>
        <p style={{ fontFamily: font.family, fontSize: 16, color: C.mocha }}>Thank you. We'll review this listing.</p>
      </div>
    );
  }

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
          Report Listing
        </span>
      </div>

      {/* Content */}
      <div className="flex-1 overflow-y-auto p-4 flex flex-col gap-4">
        {/* Warning banner */}
        <div
          className="flex items-start gap-3 rounded-2xl p-4"
          style={{ background: "#FFE8E8", border: `2px solid ${C.alert}` }}
        >
          <AlertCircle size={20} color={C.alert} className="flex-shrink-0 mt-0.5" />
          <p style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, lineHeight: "24px", letterSpacing: "-0.3125px" }}>
            False reports may result in account suspension
          </p>
        </div>

        {/* Options */}
        <div className="flex flex-col gap-3">
          {reportOptions.map((option) => {
            const isSelected = option === selected;
            return (
              <button
                key={option}
                onClick={() => setSelected(option)}
                className="flex items-center gap-3 rounded-2xl px-4"
                style={{ background: C.base, height: 58, border: `1px solid ${C.border}`, boxShadow: shadow.card }}
              >
                <div
                  className="flex items-center justify-center rounded-full flex-shrink-0"
                  style={{
                    width: 20, height: 20,
                    border: isSelected ? `2px solid ${C.gold}` : `2px solid ${C.mocha}`,
                    background: isSelected ? C.gold : "transparent",
                  }}
                >
                  {isSelected && (
                    <div className="rounded-full" style={{ width: 8, height: 8, background: C.base }} />
                  )}
                </div>
                <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
                  {option}
                </span>
              </button>
            );
          })}
        </div>

        {/* Additional details */}
        <div className="flex flex-col gap-2">
          <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
            Additional Details
          </span>
          <textarea
            placeholder="Describe the issue..."
            value={details}
            onChange={(e) => setDetails(e.target.value)}
            className="rounded-2xl p-4 outline-none resize-none"
            rows={5}
            style={{
              background: C.base,
              border: `1px solid ${C.border}`,
              fontFamily: font.family,
              fontSize: 16,
              color: C.espresso,
              letterSpacing: "-0.3125px",
            }}
          />
        </div>
      </div>

      {/* Submit button */}
      <div
        className="flex-shrink-0 flex flex-col px-4 pt-4 pb-5"
        style={{ background: C.base, borderTop: `1px solid ${C.border}` }}
      >
        <button
          onClick={handleSubmit}
          className="w-full flex items-center justify-center rounded-2xl"
          style={{
            background: selected ? C.gold : C.border,
            height: 48,
            boxShadow: selected ? shadow.button : "none",
            transition: "background 0.2s",
          }}
        >
          <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
            Submit Report
          </span>
        </button>
      </div>
    </div>
  );
}
