use core::sync::atomic::{AtomicU16, AtomicU32, AtomicU8};
use crate::device::virtio::transport::flags::DeviceStatusFlags;

#[derive(Debug, Copy, Clone)]
#[repr(C, packed)]
pub struct PciCapability {
    /// Generic PCI field: PCI_CAP_ID_VNDR
    pub cap_vndr: u8,
    /// Generic PCI field: next ptr.
    pub cap_next: u8,
    /// Generic PCI field: capability length
    pub cap_len: u8,
    /// Identifies the structure.
    pub cfg_type: CfgType,
    /// Where to find it.
    pub bar: u8,
    /// Multiple capabilities of the same type.
    pub id: u8,
    /// Pad to a full dword.
    pub padding: [u8; 2],
    /// Offset within the bar.
    /// Little-endian.
    pub offset: u32,
    /// Length of the structure, in bytes.
    /// Little-endian.
    pub length: u32,
}

#[derive(Debug, Copy, Clone)]
#[repr(u8)]
pub enum CfgType {
    /// Common Configuration.
    VirtioPciCapCommonCfg = 1,
    /// Notifications.
    VirtioPciCapNotifyCfg = 2,
    /// ISR Status.
    VirtioPciCapIsrCfg = 3,
    /// Device specific configuration.
    VirtioPciCapDeviceCfg = 4,
    /// PCI configuration access.
    VirtioPciCapPciCfg = 5,
    /// Shared memory region.
    VirtioPciCapSharedMemoryCfg = 8,
    /// Vendor-specific data.
    VirtioPciCapVendorCfg = 9,
}

/// All of these values are in Little-endian.
#[derive(Debug)]
#[repr(C)]
pub struct CommonCfg {
    /// The driver uses this to select which feature bits device_feature shows.
    /// Value 0x0 selects Feature Bits 0 to 31, 0x1 selects Feature Bits 32 to 63, etc.
    /// read-write
    pub device_feature_select: u32,
    /// The device uses this to report which feature bits it is offering to the driver:
    /// the driver writes to device_feature_select to select which feature bits are presented.
    /// read-only for driver
    pub device_feature: u32,
    /// The driver uses this to select which feature bits driver_feature shows.
    /// Value 0x0 selects Feature Bits 0 to 31, 0x1 selects Feature Bits 32 to 63, etc.
    /// read-write
    pub driver_feature_select: u32,
    /// The driver writes this to accept feature bits offered by the device.
    /// Driver Feature Bits selected by driver_feature_select.
    /// read-write
    pub driver_feature: u32,
    /// The driver sets the Configuration Vector for MSI-X.
    /// read-write
    pub config_msix_vector: u32,
    /// The device specifies the maximum number of virtqueues supported here.
    /// read-only for driver
    pub num_queues: u32,
    /// The driver writes the device status here (see 2.1).
    /// Writing 0 into this field resets the device.
    /// read-write
    pub device_status: DeviceStatusFlags,
    /// Configuration atomicity value. The device changes this every time the
    /// configuration noticeably changes.
    /// read-only for driver
    pub config_generation: u8,
    /// Queue Select. The driver selects which virtqueue the following fields refer to.
    /// read-write
    pub queue_select: u16,
    /// Queue Size. On reset, specifies the maximum queue size supported by the device.
    /// This can be modified by the driver to reduce memory requirements.
    /// A 0 means the queue is unavailable.
    /// read-write
    pub queue_size: u16,
    /// The driver uses this to specify the queue vector for MSI-X.
    /// read-write
    pub queue_msix_vector: u16,
    /// The driver uses this to selectively prevent the device from executing
    /// requests from this virtqueue. 1 - enabled; 0 - disabled.
    /// read-write
    pub queue_enable: u16,
    /// The driver reads this to calculate the offset from start of Notification
    /// structure at which this virtqueue is located. Note: this is not an offset
    /// in bytes. See 4.1.4.4 below.
    /// read-only for driver
    pub queue_notify_off: u16,
    /// The driver writes the physical address of Descriptor Area here.
    /// See section 2.6.
    /// read-write
    pub queue_desc: u16,
    /// The driver writes the physical address of Driver Area here.
    /// See section 2.6.
    /// read-write
    pub queue_driver: u16,
    /// The driver writes the physical address of Device Area here.
    /// See section 2.6.
    /// read-write
    pub queue_device: u16,
    /// This field exists only if VIRTIO_F_NOTIF_CONFIG_DATA has been negotiated.
    /// The driver will use this value to put it in the ’virtqueue number’ field
    /// in the available buffer notification structure. See section 4.1.5.2. Note:
    /// This field provides the device with flexibility to determine how virtqueues
    /// will be referred to in available buffer notifications. In a trivial case the
    /// device can set queue_notify_data=vqn. Some devices may benefit from providing
    /// another value, for example an internal virtqueue identifier, or an internal
    /// offset related to the virtqueue number.
    /// read-only for driver
    pub queue_notify_data: u16,
    /// The driver uses this to selectively reset the queue. This field exists
    /// only if VIRTIO_F_RING_RESET has been negotiated. (see 2.6.1).
    /// read-write
    pub queue_reset: u16,
}