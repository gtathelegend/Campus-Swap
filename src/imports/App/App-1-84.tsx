import svgPaths from "./svg-nrh4dy67qi";

function Container() {
  return (
    <div className="relative shrink-0 size-[128px]" data-name="Container">
      <svg className="absolute block inset-0 size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 128 128">
        <g id="Container">
          <path d={svgPaths.p15819d00} fill="var(--fill-0, #D4AF37)" />
          <g filter="url(#filter0_d_1_110)" id="Ellipse 1811">
            <path d={svgPaths.pf487500} fill="var(--fill-0, #4B3621)" />
          </g>
        </g>
        <defs>
          <filter colorInterpolationFilters="sRGB" filterUnits="userSpaceOnUse" height="84" id="filter0_d_1_110" width="79.5458" x="22.5" y="26">
            <feFlood floodOpacity="0" result="BackgroundImageFix" />
            <feColorMatrix in="SourceAlpha" result="hardAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" />
            <feOffset dy="4" />
            <feGaussianBlur stdDeviation="2" />
            <feComposite in2="hardAlpha" operator="out" />
            <feColorMatrix type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.25 0" />
            <feBlend in2="BackgroundImageFix" mode="normal" result="effect1_dropShadow_1_110" />
            <feBlend in="SourceGraphic" in2="effect1_dropShadow_1_110" mode="normal" result="shape" />
          </filter>
        </defs>
      </svg>
    </div>
  );
}

function Heading() {
  return (
    <div className="h-[36px] relative shrink-0 w-[153.133px]" data-name="Heading 1">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Medium',sans-serif] font-medium leading-[36px] left-0 not-italic text-[#4b3621] text-[24px] top-0 tracking-[0.0703px] whitespace-nowrap">Campus Swap</p>
      </div>
    </div>
  );
}

export default function App() {
  return (
    <div className="bg-[#f7f2e7] content-stretch flex flex-col gap-[24px] items-center justify-center overflow-clip relative rounded-[32px] shadow-[0px_10px_15px_-3px_rgba(0,0,0,0.1),0px_4px_6px_-4px_rgba(0,0,0,0.1)] size-full" data-name="App">
      <Container />
      <Heading />
    </div>
  );
}