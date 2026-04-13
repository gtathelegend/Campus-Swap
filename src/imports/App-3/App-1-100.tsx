function Heading() {
  return (
    <div className="h-[36px] relative shrink-0 w-full" data-name="Heading 1">
      <p className="-translate-x-1/2 absolute font-['Inter:Medium',sans-serif] font-medium leading-[36px] left-[163.5px] not-italic text-[#4b3621] text-[24px] text-center top-0 tracking-[0.0703px] whitespace-nowrap">Verify Email</p>
    </div>
  );
}

function Paragraph() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="-translate-x-1/2 absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-[164.21px] not-italic text-[#7e6d57] text-[16px] text-center top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Enter code sent to your email</p>
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

function Container2() {
  return (
    <div className="bg-white h-[56px] relative rounded-[14px] shrink-0 w-[44.5px]" data-name="Container">
      <div aria-hidden="true" className="absolute border-2 border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[14px]" />
    </div>
  );
}

function Container3() {
  return (
    <div className="bg-white h-[56px] relative rounded-[14px] shrink-0 w-[44.5px]" data-name="Container">
      <div aria-hidden="true" className="absolute border-2 border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[14px]" />
    </div>
  );
}

function Container4() {
  return (
    <div className="bg-white h-[56px] relative rounded-[14px] shrink-0 w-[44.5px]" data-name="Container">
      <div aria-hidden="true" className="absolute border-2 border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[14px]" />
    </div>
  );
}

function Container5() {
  return (
    <div className="bg-white h-[56px] relative rounded-[14px] shrink-0 w-[44.5px]" data-name="Container">
      <div aria-hidden="true" className="absolute border-2 border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[14px]" />
    </div>
  );
}

function Container6() {
  return (
    <div className="bg-white h-[56px] relative rounded-[14px] shrink-0 w-[44.5px]" data-name="Container">
      <div aria-hidden="true" className="absolute border-2 border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[14px]" />
    </div>
  );
}

function Container7() {
  return (
    <div className="bg-white h-[56px] relative rounded-[14px] shrink-0 w-[44.5px]" data-name="Container">
      <div aria-hidden="true" className="absolute border-2 border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[14px]" />
    </div>
  );
}

function Container1() {
  return (
    <div className="h-[56px] relative shrink-0 w-[327px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex gap-[12px] items-start justify-center relative size-full">
        <Container2 />
        <Container3 />
        <Container4 />
        <Container5 />
        <Container6 />
        <Container7 />
      </div>
    </div>
  );
}

function Paragraph1() {
  return (
    <div className="h-[24px] relative shrink-0 w-[327px]" data-name="Paragraph">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="-translate-x-1/2 absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-[163.98px] not-italic text-[#7e6d57] text-[16px] text-center top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Resend code in 00:45</p>
      </div>
    </div>
  );
}

function Button() {
  return (
    <div className="bg-[#d4af37] h-[48px] relative rounded-[16px] shrink-0 w-[327px]" data-name="Button">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="-translate-x-1/2 absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-[164.1px] not-italic text-[#4b3621] text-[16px] text-center top-[11.5px] tracking-[-0.3125px] whitespace-nowrap">Verify</p>
      </div>
    </div>
  );
}

export default function App() {
  return (
    <div className="bg-[#f7f2e7] content-stretch flex flex-col gap-[32px] items-start justify-center overflow-clip pl-[24px] relative rounded-[32px] shadow-[0px_10px_15px_-3px_rgba(0,0,0,0.1),0px_4px_6px_-4px_rgba(0,0,0,0.1)] size-full" data-name="App">
      <Container />
      <Container1 />
      <Paragraph1 />
      <Button />
    </div>
  );
}