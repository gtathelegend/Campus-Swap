import { useState, useEffect, useRef, useCallback } from "react";
import { RouterProvider } from "react-router";
import { Upload, CheckCircle } from "lucide-react";
import { mainRouter } from "./routes";

// ─── Design Tokens ───────────────────────────────────────────────────────────
const C = {
  espresso: "#4B3621", mocha: "#7E6D57", stone: "#9B8B7E",
  gold: "#D4AF37", cream: "#F7F2E7", base: "#FFFFFF", border: "#E8DCC8",
};
const shadow = {
  button: "0px 4px 6px 0px rgba(0,0,0,0.1), 0px 2px 4px 0px rgba(0,0,0,0.1)",
  input:  "0px 1px 3px 0px rgba(0,0,0,0.1), 0px 1px 2px -1px rgba(0,0,0,0.1)",
};
const font = { family: "'Inter', sans-serif", display: "'Manrope', sans-serif" };

// ─── Brand Logo ───────────────────────────────────────────────────────────────
function CampusSwapLogo({ size = 100 }: { size?: number }) {
  return (
    <svg width={size} height={size} viewBox="0 0 128 128" fill="none">
      <path d="M0 32C0 14.3269 14.3269 0 32 0H96C113.673 0 128 14.3269 128 32V96C128 113.673 113.673 128 96 128H32C14.3269 128 0 113.673 0 96V32Z" fill={C.gold} />
      <path d="M98.0458 46.1484C94.0807 38.6975 87.7479 32.7787 80.0463 29.3256C72.3447 25.8726 63.7127 25.0819 55.5119 27.0783C47.3111 29.0746 40.0084 33.7445 34.7556 40.351C29.5029 46.9576 26.5992 55.125 26.5025 63.5647C26.4058 72.0044 29.1217 80.2361 34.2217 86.9613C39.3217 93.6865 46.5155 98.5224 54.6684 100.706C62.8213 102.89 71.4692 102.297 79.2479 99.0214C87.0266 95.7457 93.4933 89.9735 97.628 82.6154L82.9897 74.3898C80.682 78.4966 77.0727 81.7182 72.7312 83.5465C68.3897 85.3747 63.5631 85.7055 59.0127 84.4867C54.4624 83.2679 50.4473 80.5689 47.6008 76.8154C44.7544 73.0619 43.2385 68.4675 43.2925 63.757C43.3465 59.0466 44.9671 54.4882 47.8988 50.8008C50.8305 47.1135 54.9064 44.5072 59.4835 43.3929C64.0606 42.2787 68.8783 42.72 73.1768 44.6472C77.4753 46.5745 81.0099 49.8779 83.2229 54.0365L98.0458 46.1484Z" fill={C.espresso} />
    </svg>
  );
}

// ─── Shared Primitives ────────────────────────────────────────────────────────
function PrimaryButton({ label, onClick, disabled = false }: { label: string; onClick: () => void; disabled?: boolean }) {
  return (
    <button onClick={onClick} disabled={disabled} className="w-full flex items-center justify-center rounded-2xl transition-all active:scale-[0.98]"
      style={{ background: disabled ? C.border : C.gold, color: C.espresso, height: 48, boxShadow: disabled ? "none" : shadow.button, fontFamily: font.family, fontSize: 16, lineHeight: "24px", letterSpacing: "-0.3125px", opacity: disabled ? 0.6 : 1 }}>
      {label}
    </button>
  );
}

function SecondaryButton({ label, onClick }: { label: string; onClick: () => void }) {
  return (
    <button onClick={onClick} className="w-full flex items-center justify-center rounded-2xl transition-all active:scale-[0.98]"
      style={{ background: C.base, color: C.espresso, height: 52, border: `2px solid ${C.mocha}`, fontFamily: font.family, fontSize: 16, letterSpacing: "-0.3125px" }}>
      {label}
    </button>
  );
}

function InputField({ placeholder, type, value, onChange }: { placeholder: string; type: string; value: string; onChange: (v: string) => void }) {
  const [focused, setFocused] = useState(false);
  return (
    <input type={type} placeholder={placeholder} value={value} onChange={(e) => onChange(e.target.value)}
      onFocus={() => setFocused(true)} onBlur={() => setFocused(false)}
      className="w-full outline-none rounded-[14px] px-4"
      style={{ height: 50, background: C.base, border: focused ? `1.5px solid ${C.gold}` : `1px solid ${C.border}`, boxShadow: shadow.input, color: C.espresso, fontFamily: font.family, fontSize: 16, letterSpacing: "-0.3125px", transition: "border 0.15s" }} />
  );
}

function PageHeader({ title, subtitle }: { title: string; subtitle: string }) {
  return (
    <div className="flex flex-col gap-2">
      <h1 style={{ color: C.espresso, fontFamily: font.family, fontSize: 24, lineHeight: "36px", fontWeight: 500, letterSpacing: "0.07px", margin: 0 }}>{title}</h1>
      <p style={{ color: C.mocha, fontFamily: font.family, fontSize: 16, lineHeight: "24px", letterSpacing: "-0.3125px", margin: 0 }}>{subtitle}</p>
    </div>
  );
}

function Divider() { return <div style={{ borderTop: `1px solid ${C.border}`, width: "100%" }} />; }

// ─── Progress Dots ────────────────────────────────────────────────────────────
type Screen = "splash" | "login" | "signup" | "verify" | "studentid" | "done";
const DOT_SCREENS: Screen[] = ["login", "signup", "verify", "studentid"];

function ProgressDots({ current }: { current: Screen }) {
  const idx = DOT_SCREENS.indexOf(current);
  if (idx === -1) return null;
  return (
    <div className="flex gap-2 justify-center py-5">
      {DOT_SCREENS.map((_, i) => (
        <div key={i} className="rounded-full transition-all duration-300"
          style={{ width: i === idx ? 20 : 8, height: 8, background: i === idx ? C.gold : C.border }} />
      ))}
    </div>
  );
}

// ─── Screen 1: Splash ─────────────────────────────────────────────────────────
function SplashScreen({ onNext }: { onNext: () => void }) {
  useEffect(() => { const t = setTimeout(onNext, 2000); return () => clearTimeout(t); }, [onNext]);
  return (
    <div className="flex flex-col items-center justify-center gap-5 size-full" style={{ minHeight: 480 }}>
      <div style={{ animation: "fadeInScale 0.65s cubic-bezier(0.34,1.56,0.64,1) forwards" }}>
        <CampusSwapLogo size={100} />
      </div>
      <div className="flex flex-col items-center gap-1" style={{ animation: "fadeUp 0.5s ease 0.3s both" }}>
        <p style={{ color: C.espresso, fontFamily: font.display, fontSize: 24, lineHeight: "36px", fontWeight: 700, letterSpacing: "0.07px" }}>Campus Swap</p>
        <p style={{ color: C.mocha, fontFamily: font.family, fontSize: 16, lineHeight: "24px", letterSpacing: "-0.3125px" }}>Student Second-Hand Marketplace</p>
      </div>
    </div>
  );
}

// ─── Screen 2: Login ─────────────────────────────────────────────────────────
function LoginScreen({ onLogin, onSignUp }: { onLogin: () => void; onSignUp: () => void }) {
  const [email, setEmail] = useState(""); const [password, setPassword] = useState("");
  return (
    <div className="flex flex-col gap-7 w-full px-6 pt-8 pb-4">
      <PageHeader title="Welcome Back" subtitle="Login to your account" />
      <div className="flex flex-col gap-4">
        <InputField placeholder="Enter your email..." type="email" value={email} onChange={setEmail} />
        <InputField placeholder="Enter your password..." type="password" value={password} onChange={setPassword} />
      </div>
      <div className="flex flex-col gap-4">
        <PrimaryButton label="Login" onClick={onLogin} />
        <Divider />
        <SecondaryButton label="Create New Account" onClick={onSignUp} />
      </div>
      <p className="text-center" style={{ color: C.mocha, fontFamily: font.family, fontSize: 16, lineHeight: "24px", letterSpacing: "-0.3125px" }}>
        Don't have an account?{" "}
        <button onClick={onSignUp} style={{ color: C.gold, fontFamily: font.family, fontSize: 16, fontWeight: 500 }}>Sign up</button>
      </p>
    </div>
  );
}

// ─── Screen 3: Sign Up ────────────────────────────────────────────────────────
function SignUpScreen({ onSignUp, onLogin }: { onSignUp: () => void; onLogin: () => void }) {
  const [name, setName] = useState(""); const [email, setEmail] = useState(""); const [password, setPassword] = useState("");
  return (
    <div className="flex flex-col gap-7 w-full px-6 pt-8 pb-4">
      <PageHeader title="Create Account" subtitle="Join Campus Swap today" />
      <div className="flex flex-col gap-4">
        <InputField placeholder="Your full name..." type="text" value={name} onChange={setName} />
        <InputField placeholder="University email..." type="email" value={email} onChange={setEmail} />
        <InputField placeholder="Choose a password..." type="password" value={password} onChange={setPassword} />
      </div>
      <div className="flex flex-col gap-4">
        <PrimaryButton label="Sign Up" onClick={onSignUp} />
        <Divider />
        <SecondaryButton label="Back to Login" onClick={onLogin} />
      </div>
      <p className="text-center" style={{ color: C.mocha, fontFamily: font.family, fontSize: 16, lineHeight: "24px", letterSpacing: "-0.3125px" }}>
        Already have an account?{" "}
        <button onClick={onLogin} style={{ color: C.gold, fontFamily: font.family, fontSize: 16, fontWeight: 500 }}>Login</button>
      </p>
    </div>
  );
}

// ─── Screen 4: Verify Email ───────────────────────────────────────────────────
function VerifyEmailScreen({ onVerify }: { onVerify: () => void }) {
  const [otp, setOtp] = useState(["", "", "", "", "", ""]);
  const [seconds, setSeconds] = useState(45);
  const inputRefs = useRef<(HTMLInputElement | null)[]>([]);
  useEffect(() => { if (seconds <= 0) return; const t = setTimeout(() => setSeconds((s) => s - 1), 1000); return () => clearTimeout(t); }, [seconds]);
  const handleChange = (index: number, val: string) => {
    const digit = val.replace(/\D/g, "").slice(-1); const next = [...otp]; next[index] = digit; setOtp(next);
    if (digit && index < 5) inputRefs.current[index + 1]?.focus();
  };
  const handleKeyDown = (index: number, e: React.KeyboardEvent) => { if (e.key === "Backspace" && !otp[index] && index > 0) inputRefs.current[index - 1]?.focus(); };
  const allFilled = otp.every((d) => d !== "");
  const pad = (n: number) => String(n).padStart(2, "0");
  return (
    <div className="flex flex-col items-center gap-7 w-full px-6 pt-8 pb-4">
      <div className="flex items-center justify-center rounded-full" style={{ width: 72, height: 72, background: `${C.gold}22`, border: `2px solid ${C.gold}` }}>
        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke={C.gold} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
          <rect x="2" y="4" width="20" height="16" rx="2" /><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7" />
        </svg>
      </div>
      <div className="w-full"><PageHeader title="Verify Email" subtitle="Enter the 6-digit code sent to your email" /></div>
      <div className="flex gap-2 justify-center w-full">
        {otp.map((digit, i) => (
          <input key={i} ref={(el) => { inputRefs.current[i] = el; }} type="text" inputMode="numeric" maxLength={1} value={digit}
            onChange={(e) => handleChange(i, e.target.value)} onKeyDown={(e) => handleKeyDown(i, e)}
            className="text-center outline-none transition-all"
            style={{ width: "clamp(40px,12vw,50px)", height: 56, background: C.base, borderRadius: 14, border: digit ? `2px solid ${C.gold}` : `1.5px solid ${C.border}`, color: C.espresso, fontFamily: font.family, fontSize: 22, fontWeight: 600 }} />
        ))}
      </div>
      <p style={{ color: C.mocha, fontFamily: font.family, fontSize: 16, lineHeight: "24px", letterSpacing: "-0.3125px" }}>
        {seconds > 0 ? <>Resend code in <span style={{ color: C.espresso, fontWeight: 500 }}>00:{pad(seconds)}</span></> : <button onClick={() => setSeconds(45)} style={{ color: C.gold, fontWeight: 500 }}>Resend code</button>}
      </p>
      <div className="w-full"><PrimaryButton label="Verify" onClick={onVerify} disabled={!allFilled} /></div>
      <button onClick={onVerify} style={{ color: C.gold, fontFamily: font.family, fontSize: 16, fontWeight: 500 }}>Skip for now</button>
    </div>
  );
}

// ─── Screen 5: Student ID ─────────────────────────────────────────────────────
function StudentIDScreen({ onContinue }: { onContinue: () => void }) {
  const [uploaded, setUploaded] = useState(false); const [fileName, setFileName] = useState("");
  const fileRef = useRef<HTMLInputElement>(null);
  const handleFile = (e: React.ChangeEvent<HTMLInputElement>) => { if (e.target.files?.[0]) { setUploaded(true); setFileName(e.target.files[0].name); } };
  return (
    <div className="flex flex-col items-center gap-6 w-full px-6 pt-8 pb-4">
      <div className="w-full"><PageHeader title="Student ID" subtitle="Upload your student ID for verification" /></div>
      <button onClick={() => fileRef.current?.click()} className="w-full flex flex-col items-center justify-center gap-3 transition-all active:scale-[0.98]"
        style={{ background: uploaded ? `${C.gold}11` : C.base, borderRadius: 20, border: `2px dashed ${uploaded ? C.gold : C.border}`, height: 180 }}>
        {uploaded ? (
          <><CheckCircle size={44} color={C.gold} />
            <p style={{ color: C.gold, fontFamily: font.family, fontSize: 16, fontWeight: 500 }}>Uploaded!</p>
            <p style={{ color: C.stone, fontFamily: font.family, fontSize: 13, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap", maxWidth: "80%" }}>{fileName}</p></>
        ) : (
          <><Upload size={40} color={C.mocha} />
            <p style={{ color: C.mocha, fontFamily: font.family, fontSize: 16, letterSpacing: "-0.3125px" }}>Tap to upload your student ID</p>
            <p style={{ color: C.stone, fontFamily: font.family, fontSize: 13 }}>PNG, JPG or PDF accepted</p></>
        )}
      </button>
      <input ref={fileRef} type="file" accept="image/*,.pdf" className="hidden" onChange={handleFile} />
      <div className="flex items-center gap-3 w-full px-4 rounded-2xl" style={{ background: uploaded ? `${C.gold}18` : `${C.border}66`, border: `1px solid ${uploaded ? C.gold : C.border}`, height: 54 }}>
        <div className="rounded-full flex-shrink-0" style={{ width: 10, height: 10, background: uploaded ? C.gold : C.mocha }} />
        <p style={{ color: C.espresso, fontFamily: font.family, fontSize: 16, letterSpacing: "-0.3125px" }}>
          Status: <span style={{ color: uploaded ? C.gold : C.mocha, fontWeight: 500 }}>{uploaded ? "Document Uploaded" : "Pending Approval"}</span>
        </p>
      </div>
      <div className="w-full flex flex-col gap-3">
        <PrimaryButton label="Continue" onClick={onContinue} />
        <button onClick={onContinue} style={{ color: C.gold, fontFamily: font.family, fontSize: 16, fontWeight: 500, padding: "8px 0" }}>Skip for now</button>
      </div>
    </div>
  );
}

// ─── Done Screen ──────────────────────────────────────────────────────────────
function DoneScreen({ onStart }: { onStart: () => void }) {
  return (
    <div className="flex flex-col items-center justify-center gap-7 size-full px-6 text-center" style={{ minHeight: 480 }}>
      <div className="flex items-center justify-center rounded-full" style={{ background: C.gold, width: 88, height: 88, boxShadow: shadow.button }}>
        <CheckCircle size={44} color={C.espresso} strokeWidth={2.5} />
      </div>
      <div className="flex flex-col gap-3">
        <h1 style={{ color: C.espresso, fontFamily: font.display, fontSize: 24, lineHeight: "36px", fontWeight: 700, margin: 0 }}>You're all set!</h1>
        <p style={{ color: C.mocha, fontFamily: font.family, fontSize: 16, lineHeight: "24px", letterSpacing: "-0.3125px", margin: 0 }}>Welcome to Campus Swap. Start exploring and trading with fellow students.</p>
      </div>
      <div className="w-full flex flex-col gap-3">
        <PrimaryButton label="Start Exploring" onClick={onStart} />
        <button onClick={onStart} style={{ color: C.gold, fontFamily: font.family, fontSize: 16, fontWeight: 500, padding: "8px 0" }}>View All Listings</button>
      </div>
    </div>
  );
}

// ─── Root App ─────────────────────────────────────────────────────────────────
export default function App() {
  const [screen, setScreen] = useState<Screen>("splash");
  const [onboarded, setOnboarded] = useState(false);
  const go = useCallback((s: Screen) => setScreen(s), []);

  const renderOnboarding = () => {
    switch (screen) {
      case "splash":    return <SplashScreen onNext={() => go("login")} />;
      case "login":     return <LoginScreen onLogin={() => go("verify")} onSignUp={() => go("signup")} />;
      case "signup":    return <SignUpScreen onSignUp={() => go("verify")} onLogin={() => go("login")} />;
      case "verify":    return <VerifyEmailScreen onVerify={() => go("studentid")} />;
      case "studentid": return <StudentIDScreen onContinue={() => go("done")} />;
      case "done":      return <DoneScreen onStart={() => setOnboarded(true)} />;
    }
  };

  return (
    <div
      className="min-h-screen w-full flex items-center justify-center p-4 sm:p-6"
      style={{ background: `linear-gradient(160deg, ${C.border} 0%, ${C.cream} 100%)` }}
    >
      <div
        className="relative w-full flex flex-col overflow-hidden"
        style={{
          maxWidth: 390,
          height: "min(812px, calc(100dvh - 2rem))",
          background: C.cream,
          borderRadius: 32,
          boxShadow: "0px 20px 40px -8px rgba(75,54,33,0.18), 0px 4px 12px -2px rgba(75,54,33,0.08)",
        }}
      >
        {/* Top accent bar */}
        {!onboarded && (
          <div style={{ height: 4, background: `linear-gradient(90deg, ${C.gold} 0%, #e8c96a 100%)`, flexShrink: 0, borderRadius: "32px 32px 0 0" }} />
        )}

        {onboarded ? (
          <div className="flex-1 overflow-hidden">
            <RouterProvider router={mainRouter} />
          </div>
        ) : (
          <>
            <div className="flex-1 flex flex-col overflow-hidden">{renderOnboarding()}</div>
            <ProgressDots current={screen} />
          </>
        )}
      </div>

      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Manrope:wght@700;800&display=swap');
        @keyframes fadeInScale { from{opacity:0;transform:scale(0.75)} to{opacity:1;transform:scale(1)} }
        @keyframes fadeUp { from{opacity:0;transform:translateY(12px)} to{opacity:1;transform:translateY(0)} }
        input::placeholder,textarea::placeholder { color: #9B8B7E; }
        *{box-sizing:border-box;}
        button{background:none;border:none;cursor:pointer;padding:0;}
        ::-webkit-scrollbar{display:none;}
        select{-webkit-appearance:none;}
      `}</style>
    </div>
  );
}
