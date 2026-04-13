import svgPaths from "./svg-74dj1wnxq4";

function Heading() {
  return (
    <div className="h-[36px] relative shrink-0 w-full" data-name="Heading 1">
      <p className="-translate-x-1/2 absolute font-['Inter:Medium',sans-serif] font-medium leading-[36px] left-[163.33px] not-italic text-[#4b3621] text-[24px] text-center top-0 tracking-[0.0703px] whitespace-nowrap">Student ID</p>
    </div>
  );
}

function Paragraph() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="-translate-x-1/2 absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-[163.96px] not-italic text-[#7e6d57] text-[16px] text-center top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Upload your student ID</p>
    </div>
  );
}

function Container() {
  return (
    <div className="h-[68px] relative shrink-0 w-[327px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[8px] items-start relative size-full">
        <Heading />
        <Paragraph />
      </div>
    </div>
  );
}

function Icon() {
  return (
    <div className="relative shrink-0 size-[48px]" data-name="Icon">
      <svg className="absolute block inset-0 size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 48 48">
        <g id="Icon">
          <path d="M24 6V30" id="Vector" stroke="var(--stroke-0, #7E6D57)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="4" />
          <path d="M34 16L24 6L14 16" id="Vector_2" stroke="var(--stroke-0, #7E6D57)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="4" />
          <path d={svgPaths.p38375ec0} id="Vector_3" stroke="var(--stroke-0, #7E6D57)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="4" />
        </g>
      </svg>
    </div>
  );
}

function Paragraph1() {
  return (
    <div className="h-[24px] relative shrink-0 w-[98.438px]" data-name="Paragraph">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#7e6d57] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Tap to upload</p>
      </div>
    </div>
  );
}

function Container1() {
  return (
    <div className="bg-white h-[192px] relative rounded-[24px] shrink-0 w-[327px]" data-name="Container">
      <div aria-hidden="true" className="absolute border-2 border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[24px]" />
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[16px] items-center justify-center p-[2px] relative size-full">
        <Icon />
        <Paragraph1 />
      </div>
    </div>
  );
}

function Paragraph2() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Status: Pending Approval</p>
    </div>
  );
}

function Container2() {
  return (
    <div className="bg-[#fff8e1] h-[58px] relative rounded-[16px] shrink-0 w-[327px]" data-name="Container">
      <div aria-hidden="true" className="absolute border border-[#d4af37] border-solid inset-0 pointer-events-none rounded-[16px]" />
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col items-start pb-px pt-[17px] px-[17px] relative size-full">
        <Paragraph2 />
      </div>
    </div>
  );
}

function Button() {
  return (
    <div className="bg-[#d4af37] h-[48px] relative rounded-[16px] shrink-0 w-[327px]" data-name="Button">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="-translate-x-1/2 absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-[163.84px] not-italic text-[#4b3621] text-[16px] text-center top-[11.5px] tracking-[-0.3125px] whitespace-nowrap">Continue</p>
      </div>
    </div>
  );
}

export default function App() {
  return (
    <div className="bg-[#f7f2e7] content-stretch flex flex-col gap-[32px] items-start justify-center overflow-clip pl-[24px] relative rounded-[32px] shadow-[0px_10px_15px_-3px_rgba(0,0,0,0.1),0px_4px_6px_-4px_rgba(0,0,0,0.1)] size-full" data-name="App">
      <Container />
      <Container1 />
      <Container2 />
      <Button />
    </div>
  );
}