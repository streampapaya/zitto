pub const WM_DESTROY: u32 = 0x0002;
pub const WM_PAINT: u32 = 0x000F;
pub const WM_SIZE: u32 = 0x0005;

pub const WM_MOUSEMOVE: u32 = 0x0200;
pub const WM_LBUTTONDOWN: u32 = 0x0201;
pub const WM_LBUTTONUP: u32 = 0x0202;
pub const WM_LBUTTONDBLCLK: u32 = 0x0203;

pub const WM_KEYDOWN: u32 = 0x0100;
pub const WM_KEYUP: u32 = 0x0101;

pub const WS_POPUP: u32 = 0x80000000;
pub const WS_VISIBLE: u32 = 0x10000000;

pub const WM_NCHITTEST = 0x0084;

pub const HTCLIENT = 1;
pub const HTCAPTION = 2;

pub const SW_MAXIMIZE: i32 = 3;
pub const SW_MINIMIZE: i32 = 6;
pub const SW_RESTORE: i32 = 9;

pub const IDC_ARROW: usize = 32512;
pub const MONITOR_DEFAULTTONEAREST: u32 = 2;
pub const CS_DBLCLKS: u32 = 0x0008;
pub const PS_SOLID: i32 = 0;
