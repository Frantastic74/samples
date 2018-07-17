---
uid: cutil
---

# cutil cloud utility

The **cutil** cloud utility manages devices and deployments in the cloud and enables fine-grained control over every deployment detail. 


## Compound commands

To streamline deployment for typical applications, **cutil** includes the following compound commands, which can perform many operations at once:

- **cutil component** [publish](###publish)
- **cutil component** [debugprep](###debugprep)
- **cutil device** [fieldprep](###fieldprep)
- **cutil device** [linktofeed](###linktofeed)

## Cutil commands

**cutil** provides the following commands, with full and abbreviated names:

Command | Description
-------| ------
[**component, com**](#component) | Creates and manages components and images in the cloud.
[**device, dev**](#device) | Manages devices in the cloud.
[**devicegroup, dg**](#devicegroup) | Creates and manages device groups in the cloud.
[**feed, f**](#feed) | Creates and manages feeds in the cloud.
[**imageset, ims**](#imageset) |Creates and manages image sets in the cloud.
[**login**](#login) | Provides login to the Azure Sphere tenant. By default, all cutil commands apply to the current user’s AAD login identity and tenant. The login command lets you use a different identity.
[**sku**](#sku) | Creates and manages SKUs in the cloud.

### Syntax

`cutil <command> <operation> <flags>`

### Universal flags

Universal flags can be used with any **cutil** command.

Flag | Description
-------| ------
-v, --verbose | Provides verbose output.
-?, --help | Displays help on the commands. 

### cutil identifiers

Many cutil operations require a unique name **and** a unique ID or GUID that identifies the element (com, dev, dg, f, ims, or SKU), on which to operate. They must possess both a:

- **Unique name**: If the element name is not unique to the tenant, **cutil** returns an error message "The *name* already exists."
- **GUID**: When only one such ID is required, operations typically use -i to abbreviate, regardless of the long name of the associated flag.

## component

The **component** command creates and manages components and images in the cloud. Include a subcommand for this command to succeed at runtime. Currently, seven subcommands operate specifically to component or com. 

Operation | Description
--- | ---
[**addimage, addimg**](#addimageset) | Uploads a new image and adds it to a component.
[**create** ](#create)| Creates a new component.
[**getimage, getimg** ](#getimage)| Downloads an existing image from the cloud.
[**getimagemetadata, getimgmeta** ](#getimagemetadata)| Downloads the metadata for an existing image.
[**list** ](#list)|	Lists all components in the current tenant.
[**publish** ](#publish)|	Uploads a new image, adds it to a new image set, and adds the image set to an existing feed.

### addimage

The **addimage** operation uploads a new image to the cloud and adds it to a component. The component ID is not required because **cutil** reads it from the application manifest. Use the --autocreatecomponent (-c) flag to create the component if it does not already exist. 

<details><summary>Flags</summary>
<p>

Flag | Description
-------| ------
-c, --autocreatecomponent | Creates a new component for the image if one does not already exist.
-f, --filepath *path* | Specifies the path to the image file to upload. Required.
</p>
</details>

#### Example

```sh
cutil component addimage -c -f "C:\Users\User\Documents\Visual Studio 2017\Projects\Mt3620BlinkEx\Mt3620BlinkEx\bin\ARM\Debug\MT3620BlinkEx.imagepackage"

Uploading image from file 'C:\Users\User\Documents\Visual Studio 2017\Projects\Mt3620BlinkEx\Mt3620BlinkEx\bin\ARM\Debug\MT3620BlinkEx.imagepackage':
 --> Image ID:       dc59be07-1feb-4be9-a5dc-42664dba4871
 --> Component ID:   4275ecb3-5cf8-4147-9bfb-a7e8f3955e96
 --> Component name: 'Mt3620BlinkEx'
Successfully uploaded image with ID 'dc59be07-1feb-4be9-a5dc-42664dba4871' to component 'Mt3620BlinkEx' with ID '4275ecb3-5cf8-4147-9bfb-a7e8f3955e96'.
Command completed successfully in 00:00:20.4555421.
```

### create

The **create** operation creates a new component, given a component ID and a name.

<details><summary>Flags</summary>
<p>

Flag | Description
-------| ------
-i, --componentid *GUID* | Specifies the GUID of the component. This value appears in the ComponentId field of the app_manifest.json file for the application. Required.
-n, --name *string* | Specifies a name for the component. Component names must be unique within a tenant. Required.
</p>
</details>

#### Example

```sh
cutil component create -i 83fac70c-072f-4f58-96bb-1be5c3557819 -n MT3620Uart1

Creating new component 'MT3620Uart1'.
Successfully created component 'MT3620Uart1' with ID '83fac70c-072f-4f58-96bb-1be5c3557819'.
Command completed successfully in 00:00:07.7393213.
```

### getimage

The **getimage** operation downloads a copy of an image that has already been added to a component.

<details><summary>Flags</summary>
<p>

Flag | Description
-------| ------
-f filepath *path* | Specifies the path and filename to save changes. Path can be relative to the current directory. Required
-i, --imageid *GUID* | Specifies the image ID of the image to download. Required

</p>
</details>

#### Example

```sh
cutil component getimage -i dc59be07-1feb-4be9-a5dc-42664dba4871 -f "BlinkEx.imagepackage"

Getting the image with ID 'dc59be07-1feb-4be9-a5dc-42664dba4871'.
Successfully downloaded image to location 'BlinkEx.imagepackage'.
Command completed successfully in 00:00:08.7115126.
```

### getimagemetadata

The **getimagemetadata** operation downloads the metadata for an image that has already been added to a component.

<details><summary>Flags</summary>
<p>

Flag | Description
-------| ------
i, --componentid *GUID* | Specifies the image GUID on which to return the metadata. Required.
</p>
</details>

#### Example

```sh
cutil component getimagemetadata -i dc59be07-1feb-4be9-a5dc-42664dba4871

Getting the metadata for image with ID 'dc59be07-1feb-4be9-a5dc-42664dba4871'.
Successfully retrieved image metadata:
 -> Image ID:     dc59be07-1feb-4be9-a5dc-42664dba4871
 -> Component ID: 4275ecb3-5cf8-4147-9bfb-a7e8f3955e96
 -> Name:         Mt3620BlinkEx
 -> Description:
Command completed successfully in 00:00:08.3633986.
```

### list

The **list** operation lists all components in the current tenant.

#### Example

```sh
cutil component list
Listing all components.
Retrieved components:
--> [afb39a19-4198-4b87-a5c6-46fa40e87cf3] 'MyIoTHubApp':
--> [4275ecb3-5cf8-4147-9bfb-a7e8f3955e96] 'Mt3620BlinkEx':
--> [617b716c-714c-4008-a56e-bd654203273b] 'TestApp':
--> [34abd599-89ea-49af-bd80-21f6f63c5f8f] 'UartDoc':
--> [37c8baa4-33db-419d-b9b3-94e42964a3e6] 'Mt3620AzureIoTHub7':
--> [03ee58ce-d091-43a8-a2ac-0bb2920285db] 'Mt3620AzureIoTHub1':
--> [07a938d8-484f-4f3d-a0fa-e4f463acf1ff] 'flipdot_iot_central':
--> [36f987ed-dc26-42b1-bd1b-14a889fb83f4] 'blink test app':
--> [16995a70-377f-4bd2-b29d-1b0fffcbe287] 'Mt3620Blink3':
--> [8fb105a3-35d0-423a-9427-a21852623965] 'Mt3620Blink5':
--> [88d7fe6a-165a-443c-86f0-798531561f44] 'Mt3620Blink6':
--> [350ef47d-fa94-47fe-95bc-e2d393b589ab] 'Mt3620Blink1':
Command completed successfully in 00:00:06.1894094.
```

### publish

The **publish** operation "publishes" a new image set for an existing component to an existing feed. It uploads a new image, adds it to a new image set, and adds the new image set to an existing feed. It combines the tasks of several other **cutil** commands:

- **cutil com addimg**
- **cutil imageset create**
- **cutil feed addimageset**

<details><summary>Flags</summary>
<p>

Flag | Description
-------| ------
-f, --feedid *GUID* | Specifies the GUID of the feed to which to add the image set. The feed must already exist and must deliver a component that has the same component ID as the specified image. Required.
-i, --imagepath *filepath* | Specifies the path and filename of the image to upload. The command auto-generates a component ID based on the information in the image package if a component with that ID does not already exist. Required.
-n, --newimagesetname *string* | Specifies a name for the new image set to be created. The name must be unique within the tenant. If omitted, a name is generated from the image metadata. Optional.
</p>
</details>

#### Example

The following example uploads a new image for the existing Mt3620Blink3 component, creates an image set, and adds the image set to a feed that delivers the Mt3620Blink3 component.

```sh
cutil com publish -f d755a1b9-192d-4769-aad5-5d579178242f -i "C:\Users\User\Source\Repos\Mt3620Blink3\Mt3620Blink3\bin\ARM\Debug\Mt3620Blink3.imagepackage"
Publishing image 'C:\Users\User\Source\Repos\Mt3620Blink3\Mt3620Blink3\bin\ARM\Debug\Mt3620Blink3.imagepackage' to feed with ID 'd755a1b9-192d-4769-aad5-5d579178242f'.
Uploading image from file 'C:\Users\User\Source\Repos\Mt3620Blink3\Mt3620Blink3\bin\ARM\Debug\Mt3620Blink3.imagepackage':
 --> Image ID:       '4eb71b48-16a2-4f31-a338-bb8c0e5f7386'
 --> Component ID:   '16995a70-377f-4bd2-b29d-1b0fffcbe287'
 --> Component name: 'Mt3620Blink3'
Creating new image set with name 'ImageSet-Mt3620Blink3-2018.04.26-14.33.07' for image with ID '4eb71b48-16a2-4f31-a338-bb8c0e5f7386'.
Adding image set with ID 'adfd80e1-43d9-4359-99fe-31df0c834d7a' to feed with ID 'd755a1b9-192d-4769-aad5-5d579178242f'.
Successfully published image 'C:\Users\User\Source\Repos\Mt3620Blink3\Mt3620Blink3\bin\ARM\Debug\Mt3620Blink3.imagepackage' to feed with ID 'd755a1b9-192d-4769-aad5-5d579178242f'.
Command completed successfully in 00:00:11.3067837.
```

The command did not include the optional --newimagesetname flag, so **cutil** creates a name that includes the filename of the image package and a timestamp. The **cutil imageset get** command shows the details for this image set:

#### Example

```sh
cutil ims get -i adfd80e1-43d9-4359-99fe-31df0c834d7a
Getting image set with ID 'adfd80e1-43d9-4359-99fe-31df0c834d7a'.
Successfully retrieved image set 'adfd80e1-43d9-4359-99fe-31df0c834d7a':
 --> ID:   [adfd80e1-43d9-4359-99fe-31df0c834d7a]
 --> Name: 'ImageSet-Mt3620Blink3-2018.04.26-14.33.07'
Images to be installed:
 --> [ID: 4eb71b48-16a2-4f31-a338-bb8c0e5f7386]
Command completed successfully in 00:00:04.7822167.
```

## device

The **device** command manages devices in the cloud.

Option | Description
-------| ------
[**applycapability**](#applycapability) |	Applies a capability file to an attached device.
[ **claim**](#claim) |Claims a previously unclaimed device in the cloud.
[**debugprep, debug**](#debugprep) | Sets up a device for local debugging by combining the tasks of several other **cutil** commands.
[**fieldprep, field**](#fieldprep)| Sets up a device for OTA updates by combining the tasks of several other **cutil** commands.
[**Get**](#get) | Gets details about a device from the cloud.
[**getcapability**](#getcapability)| Gets a capability file and optionally applies it to an attached device
[**getimageset, getims**](#getimageset) | Returns information about the image sets to be deployed to the device.
[**linktofeed, linkf**](#linktofeed) | Links a device to a feed	
[**setdevicegroup, setdg**](#setdevicegroup) | Moves the device into a device group.
[**setsku**](#setsku)| Sets the product SKU for a device.

### applycapability

The **applycapability** operation applies an existing capability file to the attached device.

<details><summary>Flags</summary>
<p>

Flag | Description
-------| ------
-- filepath |Specifies the path and name of the capability file to apply.
</p>
</details>

#### Example

```sh
cutil device applycapability --filepath appCapability.bin
Applying device capability configuration to device.
Successfully applied device capability configuration to device.
Command completed successfully in 00:00:01.3602719.
```

### claim

The **claim** operation associates a device with your Azure Sphere tenant. Before you claim a device, be sure that you are logged in to the tenant that you plan to use with Azure Sphere. See the [**login**](#login) command for more information. 

<details><summary>Flags</summary>
<p>

Flag  | Description
-------| ------
-a, --attached |Claims the Azure Sphere device that is currently attached to the PC.
 -i, --deviceid *string*| Claims the device that has the specified device ID.

> [!IMPORTANT]
> This operation requires either the --attached flag or the --deviceid flag.
</p>
</details>

### Example

```sh
cutil device claim -a

Claiming device.
Claiming attached device ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED' into tenant ID 'd343c263-4aa3-4558-adbb-d3fc34631800'.
Successfully claimed device ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED' into tenant ID 'd343c263-4aa3-4558-adbb-d3fc34631800'.
Command completed successfully in 00:00:05.5459143.
```

### debugprep

The **debugprep** operation sets up the attached device for local debugging by enabling the appDevelopment capability and assigning the device to a device group that does not apply OTA application updates; it leaves any existing applications on the device. The appDevelopment capability enables you to sideload SDK-signed image packages to the device and to start, stop, debug, and delete any image package from the device. This command works only on an attached device.  

This command combines the work of several other **cutil** commands:

- **cutil device getcapability -type appDevelopment** 
- **cutil devicegroup get** 
- **cutil device setdevicegroup**
- **cutil device applycapability**

<details><summary>Flags</summary>
<p>

Flag | Description
-------| ------
-d, --devicegroupid *GUI* | Specifies an existing device group that does not enable OTA updates for applications. If this flag is omitted, the operation assigns the device to a Microsoft-created default group that does not apply OTA updates to applications. If your device is already a member of a device group that does not enable application updates and you want it to remain in that group, supply the device group ID with this flag. Optional
</p>
</details>

#### Example

```sh
cutil dev debugprep

Getting device capability configuration for application development.
Downloading device capability configuration for device ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED'.
Successfully downloaded device capability configuration.
Successfully wrote device capability configuration file 'C:\Users\Administrator\AppData\Local\Temp\tmpD732.tmp'.
Setting device group ID 'a6df7013-c7c2-4764-8424-00cbacb431e5' for device with ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED'.
Successfully disabled over-the-air updates.
Unlocking device for application development.
Applying device capability configuration to device.
Successfully applied device capability configuration to device.
The device is rebooting.
Unlocked device for application development.
Successfully set up device 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED' for application development, and disabled over-the-air updates.
Command completed successfully in 00:00:17.1861625.
```

### fieldprep

The **fieldprep** operation sets up a device to receive OTA updates, deletes any existing applications, and removes the appDevelopment capability. It requires a device to be attached to the PC and operates only on the attached device. It combines the work of several other **cutil** and **dutil** commands:

- **dutil sideload delete**
- **cutil device getcapability --type none**
- **cutil sku create**
- **cutil device setsku**
- **cutil devicegroup create**
- **cutil device setdevicegroup**
- **cutil device applycapability**

The specific tasks that **fieldprep** performs depend on the whether a product SKU and device group have already been assigned for this device. If the product SKU or the device group does not already exist, the command creates it and assigns it to the device, provided that a SKU name or a device group name is supplied with the appropriate flag. See [Examples](#example-10) for details.  

<details><summary>Flags</summary>
<p>

Flag  | Description
-------| ------
 -r, --devicegroupid *Guid*| Sets the ID of the device group to which to add the device. If this flag is omitted, the command creates a new device group and enables application updates for the new group. Either --devicegroupid or --newdevicegroupname is required
 -g, --newdevicegroupname *String* | Specifies a name for the new device group to create. The name must be unique within the tenant. Use this flag only if you have not already set up a device group for OTA updates. Whenever possible, use an existing device group to avoid cluttering the tenant with unneeded groups.
-n, --newskuname *String* | Specifies a name for the new product SKU to create for the device. The name must be unique within the tenant. Use this flag only if you do not use the --skuid flag. If you already have a product SKU that is appropriate for this device, supply it with the --skuid flag to avoid cluttering your tenant with numerous SKUs that are only used once. If neither the --newskuname nor the --skuid flag is present, the command checks whether the device already has a product SKU and if so, uses it; otherwise, the command fails.
-d, --skudescription *String*  | Specifies a string that describes the new product SKU to create. Ignored if the device already has a product SKU.
-s --skuid *GUID* | Assigns an existing product SKU to the device.
</p>
</details>

#### Examples

Example 1. Create a product SKU and device group for device

This example creates a new product SKU and a new device group, and assigns both to the attached device.

```sh
cutil dev fieldprep --newdevicegroupname AppUpdateGroup --newskuname TestSKU
```

As the output shows, the command deletes the existing application from the device, removes the appDevelopment capability, creates a device group named AppUpdateGroup, creates a product SKU named TestSKU, and assigns both the device group and the product SKU to the attached device. The new device group is enabled for OTA loading of application updates.

```
Removing applications from device.
App deleted.
Successfully removed applications from device.
Locking device.
Downloading device capability configuration for device ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED'.
Successfully downloaded device capability configuration.
Applying device capability configuration to device.
Successfully applied device capability configuration to device.
The device is rebooting.
Successfully locked device.
Creating a new device group with name 'AppUpdateGroup'.
Setting device group ID 'bbc91f02-1de4-43a3-bcf2-f6f0994ac723' for device with ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED'.
Creating a new SKU with name 'TestSKU'.
Setting product SKU to '5d88f658-be0c-4814-8319-473f21f4f88f' for device with ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED'.
Successfully set up device 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED' for OTA loading.
Command completed successfully in 00:00:18.0072081.
```

Example 2. Assign existing product SKU and device group to device 

This example assigns an existing product SKU and device group to the attached device.

```sh
cutil dev fieldprep --skuid 2bc8c605-6f8f-4802-ba69-c57d63e9c6dd --devicegroupid d80bf785-acae-497c-a62c-21a6ce65b81f
```

```
Getting the details of device group with ID ''.
Removing applications from device.
No app present.
Successfully removed applications from device.
Locking device.
Downloading device capability configuration for device ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED'.
Successfully downloaded device capability configuration.
Applying device capability configuration to device.
Successfully applied device capability configuration to device.
The device is rebooting.
Successfully locked device.
Setting device group ID 'd80bf785-acae-497c-a62c-21a6ce65b81f' for device with ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED'.
Setting product SKU to '2bc8c605-6f8f-4802-ba69-c57d63e9c6dd' for device with ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED'.
Successfully set up device 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED' for OTA loading.
Command completed successfully in 00:00:12.0638169.
```
Example 3. Assign device to different device group

This example is similar to the preceding example, but retains the existing product SKU for the device. Here the **fieldprep** operation changes the device group to which the device belongs and removes the appDevelopment capability. This command is useful for moving a device from a development environment that does not enable OTA application updates to a production environment that does.

```sh 
cutil device fieldprep --devicegroupid 64dbcfd8-ef37-496a-8761-b755c6af8266
```

``` 
Getting the product SKU for device with ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED'.
Getting the details of device group with ID ''.
Removing applications from device.
No app present.
Successfully removed applications from device.
Locking device.
Downloading device capability configuration for device ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED'.
Successfully downloaded device capability configuration.
Applying device capability configuration to device.
Successfully applied device capability configuration to device.
The device is rebooting.
Successfully locked device.
Setting device group ID '64dbcfd8-ef37-496a-8761-b755c6af8266' for device with ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED'.
Successfully set up device 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED' for OTA loading.
Command completed successfully in 00:00:11.1988981.
```

### get

The **get** operation returns information about a device.

<details><summary>Flags</summary>
<p>

Flag  | Description
-------| ------
-a, --attached | Returns information about the Azure Sphere device that is currently attached to the PC.
-i, --deviceid *String* | Returns information about the device that has the specified device ID.

> [!IMPORTANT]
> This operation requires either the --attached flag or the --deviceid flag.
</p>
</details>

#### Example

```sh
cutil device get -a

Getting the properties of attached device ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED' from the cloud.
Retrieved details for device with ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED':
 --> Device group: 'DocMT' with ID 'fbb064a6-df8d-4d21-8a45-d4ff0fb8de95'
 --> SKU: '9d606c43-1fad-4990-b207-554a025e0869' of type 'Chip'
 --> SKU: 'ee4c1baa-1887-4da5-aaf9-76c0b59cda70' of type 'Product'
Command completed successfully in 00:00:07.3914526.
```

### getcapability

The **getcapability** operation gets a capability file and optionally applies it to the attached device. 

<details><summary>Flags</summary>
<p>

Flag  | Description
-------| ------
--apply *filename* | Applies the capability file to the attached device. Requires the --attached flag.
--attached | Gets a capability file for the attached device.
--deviceid id |	Specifies the id of the device for which to get the capability file. Cannot be used with the --apply flag.
--output *filepath* |	Saves the capability in a file on the local PC for later use in sideloading applications to the device. You must specify a directory and filename.
--type **appDevelopment none**| Specifies the type of capability, either appDevelopment or none. The appDevelopment capability enables a user to sideload SDK-signed applications on the device and to start, stop, debug, or delete applications on the device. Specify 'none' to create a capability file that removes the appDevelopment capability from the device.
</p>
</details>

#### Example

The following example gets the appDevelopment capability for the attached device, saves it in a file named appDevCapability, and applies it to the attached device.

```sh
cutil device getcapability --attached --apply --type appDevelopment --output ./appcapability.bin
```

```
Downloading device capability configuration for device ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED'.
Successfully downloaded device capability configuration.
Successfully wrote device capability configuration file './appcapability.bin'.
Applying device capability configuration to device.
Successfully applied device capability configuration to device.
The device is rebooting.
Command completed successfully in 00:00:20.3989430.
```

### getimageset

The **getimageset** operation returns information about the current image set for a device. The current image set is the image set that will be deployed to the device the next time an OTA update occurs. It is not necessarily the image set that is currently running on the device. 

<details><summary>Flags</summary>
<p>

Flags  | Description
-------| ------
-a, --attached | Returns information about the current image set for the Azure Sphere device that is currently attached to the PC.
-f, --full |Lists all image sets that will be installed on the device. By default, only application image sets are listed.
-i, --deviceid *String* |	Returns information about the current image set for the Azure Sphere device that has the specified device ID.

> [!IMPORTANT]
> This operation requires either the --attached flag or the --deviceid flag.
</p>
</details>

#### Example

```sh
cutil device getimageset -a
```

```
Getting the image set details for attached device ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED' from the cloud.
Successfully retrieved the current image set for device with ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED' from the cloud:
 --> ID:   [e88b0fb2-fa0e-4f2c-a68e-8a8c4b9bffd1]
 --> Name: 'DocTestBlink'
Images to be installed:
 --> [ID: b2a6f671-dc4e-494f-8a27-acf7439d014b]
Command completed successfully in 00:00:08.0821439.
```

### linktofeed

The **linktofeed** operation provides an abbreviated way to deploy an application. It creates a feed and assigns that feed to the devices in the same device group as a specified device. It combines the tasks of the following **cutil** commands:

- **cutil component addimage**
- **cutil feed create** 
- **cutil devicegroup addfeed**
- **cutil imageset create** 
- **cutil feed addimageset**

<details><summary>Flags</summary>
<p>

Flags  | Description
-------| ------
-a, --attached | Selects the device group to which the attached the Azure Sphere device belongs. Either the --attached flag or the --deviceid flag is required.
-c, --componentid *GUID* | Specifies the component ID of the application. If you use the --newfeedname flag to create a new feed, you must also supply either the --componentid or the --imagepath flag.
-d, --dependentfeedid *GUID* | Specifies the ID of the dependent feed for the application. Application feeds depend on the latest Azure Sphere OS feed, which is currently named Preview MT3620 Feed. Required when creating a new feed.
-i, --deviceid *String* | Selects the device group for the Azure Sphere device with the specified device ID. Either the --attached flag or the --deviceid flag is required.
-f, --feedid *GUID* | Specifies the ID of the feed to link to the device group for the specified device. If you omit this flag, **cutil** creates a new feed and assigns it the friendly name that you specify with the optional --newfeedname flag. If you already have a feed for this component, use it to avoid cluttering your tenant with redundant feeds. Either the --feedid flag or the --newfeedname flag is required.
-p, --imagepath *String* | Specifies the path to the image package to upload. If you omit this flag, the feed is created but is not assigned an initial image set. Optional.
-n, --newfeedname *GUID* | Specifies a friendly name for the new feed. Use only if you do not specify a feed ID with the --feedid flag. If you use the --newfeedname flag to create a new feed, you must also supply either the --componentid or the --imagepath flag. Either the --feedid flag or the --newfeedname flag is required.
-s, --newimagesetname *String* | Specifies a friendly name for the new image set that the command creates when you use the --imagepath flag. The name must be unique within the tenant. If you specify an image path but not an image set name, **cutil** automatically generates a name for the image set.
</p>
</details>

#### Examples

The first example creates a new feed, a new component, and a new image set. The new feed depends on the Preview MT3620 feed and is named BlinkLink. 

```sh
cutil device linktofeed --attached --dependentfeedid edd33e66-9b68-44c8-9d23-eb60f2e5018b --imagepath "C:\Users\User\Documents\Visual Studio 2017\Projects\Mt3620Blink5\Mt3620Blink5\bin\ARM\Debug\Mt3620Blink5.imagepackage" --newfeedname Model100AppFeedOTA --newimagesetname Model100Appv1.0
```

```
Getting the details for device with ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED'.
Uploading image from file 'C:\Users\User\Documents\Visual Studio 2017\Projects\Mt3620Blink5\Mt3620Blink5\bin\ARM\Debug\Mt3620Blink5.imagepackage':
 --> Image ID:       'b66f1398-4ad6-4f12-be84-8ad607676ec3'
 --> Component ID:   '8fb105a3-35d0-423a-9427-a21852623965'
 --> Component name: 'Mt3620Blink5'
Create a new feed with name 'Model100AppFeedOTA'.
Adding feed with ID '8e2d3b19-bb01-4e36-b974-5b2f8df502e9' to device group with ID 'c0346077-eb9e-4dbc-85ad-03313867be69'.
Creating new image set with name 'Model100Appv1.0' for image with ID 'b66f1398-4ad6-4f12-be84-8ad607676ec3'.
Adding image set with ID '70207e9a-d080-42d7-899e-fb02822fbc32' to feed with ID '8e2d3b19-bb01-4e36-b974-5b2f8df502e9'.
Successfully linked device 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED' to feed with ID '8e2d3b19-bb01-4e36-b974-5b2f8df502e9'.
Command completed successfully in 00:00:25.5193828.
```

The next example creates a new feed for an existing component. The feed is dependent on the Preview MT3620 Feed and is named BlinkLink. The feed services the devices in the same device group as the attached device.  

```sh
cutil dev linktofeed -a -c 16995a70-377f-4bd2-b29d-1b0fffcbe287 -n BlinkLink --dependentfeedid edd33e66-9b68-44c8-9d23-eb60f2e5018b
```

```
Getting the details for device with ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED'.
Create a new feed with name 'BlinkLink'.
Adding feed with ID '6daf66aa-5a3e-41f9-9659-6c30a2f7673f' to device group with ID 'd80bf785-acae-497c-a62c-21a6ce65b81f'.
Successfully linked device 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED' to feed with ID '6daf66aa-5a3e-41f9-9659-6c30a2f7673f'.
Command completed successfully in 00:00:07.1315217.
```

The **cutil feed get** command shows the resulting feed. No image sets are associated with the feed because the preceding **cutil dev linktofeed** command did not specify an image path. You can later add an image set to the feed by using the **cutil feed addims** command.

```sh
cutil feed get -i 6daf66aa-5a3e-41f9-9659-6c30a2f7673f
```

```
Getting feed with ID '6daf66aa-5a3e-41f9-9659-6c30a2f7673f'.
Retrieved feed 'BlinkLink' of type 'ThirdPartyApplicationFeed' with ID '6daf66aa-5a3e-41f9-9659-6c30a2f7673f'.
- SKU sets supported by this feed:
   -> '9d606c43-1fad-4990-b207-554a025e0869, 2bc8c605-6f8f-4802-ba69-c57d63e9c6dd'
- Targeted Component ID: '16995a70-377f-4bd2-b29d-1b0fffcbe287'.
- Feeds this feed depends on:
   -> 7bb28182-50e9-41f4-a357-1d672ba3bdd6
- This feed contains no image sets.
Command completed successfully in 00:00:03.9658486.
```

### setdevicegroup

The **setdevicegroup** operation moves a device to a device group.

<details><summary>Flags</summary>
<p>

Flags | Description
-------| ------ 
-a, --attached | Sets the device group for the Azure Sphere device that is currently attached to the PC.
-d, --devicegroup *GUID* | Specifies the device group to which to move the device. Required.
-i, --deviceid *String* | Sets the device group for the Azure Sphere device with the specified device ID.

> [!IMPORTANT]
> This operation requires either the --attached flag or the --deviceid flag.
</p>
</details>

#### Example

```sh
cutil device setdevicegroup -a -d fbb064a6-df8d-4d21-8a45-d4ff0fb8de95
```

```
Moving attached device 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED' to device group 'fbb064a6-df8d-4d21-8a45-d4ff0fb8de95' in the cloud.
Successfully moved device 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED' to device group 'fbb064a6-df8d-4d21-8a45-d4ff0fb8de95' in the cloud.
Command completed successfully in 00:00:06.0637112.
```

## setsku

The **setsku** operation sets the product SKU for a connected device that contains a Azure Sphere device.

<details><summary>Flags</summary>
<p>

Flags  | Description
-------|------ 
-a, --attached |	Sets the product SKU for the Azure Sphere device that is currently attached to the PC.
-i, --deviceid *String*	| Sets the product SKU for the Azure Sphere device with the specified device ID.
-s, --SkuId*GUID*	| Specifies the product SKU to set for the device. Use cutil sku create to create a product SKU and cutil sku list to list the SKUs in the current tenant.

> [!IMPORTANT]
> This operation requires either the --attached flag or the --deviceid flag.
</p>
</details>

#### Example

```sh
cutil device setsku -a -s ee4c1baa-1887-4da5-aaf9-76c0b59cda70
```

```
Setting SKU 'ee4c1baa-1887-4da5-aaf9-76c0b59cda70' for attached device ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED' in the cloud.
Successfully set SKU 'ee4c1baa-1887-4da5-aaf9-76c0b59cda70' for device ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED' in the cloud.
Command completed successfully in 00:00:10.7239012.
```

## devicegroup

The **devicegroup** command manages device groups in the cloud.

Operation  | Description
-------| ------ 
[**addfeed, addf**](#addfeed) |	Adds a feed to a device group.
**create** |	Creates a device group.
**get** |	Returns information about a device group.
**list** |	Lists all device groups.
**listdevices, listdev** |	Lists all devices in a device group.
[**listfeeds, listf**](#listfeeds) | Lists all feeds that are assigned to a device group.


### addfeed

The **addfeed** operation assigns a feed to a device group.

<details><summary>Flags</summary>
<p>

Flag | Description
-------| ----
-f, --feedid *GUID* |	Specifies the feed to assign to the device group.
-i, --devicegroupid *GUID* |	Specifies the device group to which to add the feed.
</p>
</details>

#### Example

```sh
cutil devicegroup addfeed -f 8d297fc2-4c1b-4b81-9332-94e09f2bf0dd -i fbb064a6-df8d-4d21-8a45-d4ff0fb8de95

Adding feed '8d297fc2-4c1b-4b81-9332-94e09f2bf0dd' to device group 'fbb064a6-df8d-4d21-8a45-d4ff0fb8de95'.
Successfully added feed with ID '8d297fc2-4c1b-4b81-9332-94e09f2bf0dd' to device group with ID 'fbb064a6-df8d-4d21-8a45-d4ff0fb8de95'.
Command completed successfully in 00:00:05.1220735.
```

### create

The **create** operation creates a new device group and assigns it a friendly name. Device group names must be unique within the tenant. 

By default, application software updates are enabled for all device groups, so that devices receive OTA deployments of application software automatically. You can change this default by specifying the --noapplicationupdates (-a) flag when you create a group. Disabling updates means that the devices in the group will not receive OTA updates and must instead be updated by sideloading, either through Visual Studio or by using the [**dutil sideload**](dutil.md#sideload) command.

<details><summary>Flags</summary>
<p>

Flag | Description
-------|----
-a, --noapplicationupdates| Disables application updates for this device group.
-n, --name *String*	| Specifies an alphanumeric name for the device group. If the name includes embedded spaces, enclose it in quotation marks. The name must be unique within the tenant. Required.
</p>
</details>

#### Examples

```sh
cutil devicegroup create -n DocMT
```

```
Creating device group with name 'DocMT'.
Successfully created device group 'DocMT' with ID 'fbb064a6-df8d-4d21-8a45-d4ff0fb8de95',
  and update policy: Accept all updates from the cloud.
Command completed successfully in 00:00:07.0428563.
```

### get

The **get** operation returns information about a device group.

<details><summary>Flags</summary>
<p>

Flag | Description
-------| ------ 
-i --devicegroup *GUID* | Specifies the GUID that identifies the device group. Required.
</p>
</details>

#### Example

```sh
cutil devicegroup get -i fbb064a6-df8d-4d21-8a45-d4ff0fb8de95

Getting device group with ID 'fbb064a6-df8d-4d21-8a45-d4ff0fb8de95'.
Successfully retrieved the device group:
  --> ID:            'fbb064a6-df8d-4d21-8a45-d4ff0fb8de95'
  --> Name:          'DocMT'
  --> Update Policy: Accept all updates from the cloud.
Command completed successfully in 00:00:04.7659196.
```

### list

The **list** operation lists all device groups in the current tenant.

#### Example

```sh
cutil devicegroup list

Listing all device groups.
 --> [ID: 19066e8f-c4a0-4b83-8436-73caf0656069] 'TestGroup1'
 --> [ID: a56c666c-38fc-4aa5-a9c8-8172cd224c26] 'TestGroup1-no updates'
 --> [ID: fbb064a6-df8d-4d21-8a45-d4ff0fb8de95] 'DocMT'
 Command completed successfully in 00:00:05.5871572.
```

### listdevices

The **listdevices** operation lists each device in a device group, along with any SKUs that are assigned to the device.

<details><summary>Flags</summary>
<p>

Flag | Description
-------| ------
-i --devicegroup *GUID* | Specifies the GUID that identifies the device group. Required.
</p>
</details>

#### Example

```sh
cutil devicegroup listdevices -i fbb064a6-df8d-4d21-8a45-d4ff0fb8de95
```

```
Listing all devices in device group fbb064a6-df8d-4d21-8a45-d4ff0fb8de95.
Device with ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED':
 --> SKU: [ID: 9d606c43-1fad-4990-b207-554a025e0869], Type: 'Chip'
 --> SKU: [ID: ee4c1baa-1887-4da5-aaf9-76c0b59cda70], Type: 'Product'
Command completed successfully in 00:00:05.6792395.
```

### listfeeds

The **listfeeds** operation lists all feeds that are assigned to a device group.

<details><summary>Flags</summary>
<p>

Flag | Description
-------| ------
-i, 
--devicegroupid *GUID* |	Specifies the GUID that identifies the device group. Required. 
</p>
</details>

#### Example

```sh
cutil devicegroup listfeeds -i fbb064a6-df8d-4d21-8a45-d4ff0fb8de95
```

```
Get all supported feeds that target device group with ID 'fbb064a6-df8d-4d21-8a45-d4ff0fb8de95'.
 --> Device group 'fbb064a6-df8d-4d21-8a45-d4ff0fb8de95' contains feed '8d297fc2-4c1b-4b81-9332-94e09f2bf0dd',
     targeting SKU set '9d606c43-1fad-4990-b207-554a025e0869', 'ee4c1baa-1887-4da5-aaf9-76c0b59cda70'.
Command completed successfully in 00:00:05.1766496.
```

## feed

The **feed** command creates and manages feeds, which deliver software updates.

Operation | Description
-------| ------ 
**addimageset, addims**	| Adds an image set to a feed.
**create** | Creates a feed.
**get** |	Returns information about a feed.
**list** |	Lists all feeds.
**listdevicegroups, listdg** |	Lists all device groups that a feed targets.
**listimagesets, listims** |	Lists all image sets that are assigned to a feed.


### addimageset

The **addimageset** operation adds an image set to a feed. The image set must represent the component ID that was specified with the [cutil feed create](#create-2) command.

<details><summary>Flags</summary>
<p>

Flag | Description
-------| ------ 
-i, --feedid *GUID* |	Specifies the ID of the feed to which to add the image set. Required.
-s, --imagesetid *GUID* |	Specifies the ID of the image set to add to the feed. Required.
</p>
</details>

#### Example

```sh
cutil feed addimageset --feedid 34b62e08-208e-4707-8ffa-f01613f74e2e --imagesetid 16d84454-08d0-4b35-aa7c-4ebecea3664f

Adding image set with ID '16d84454-08d0-4b35-aa7c-4ebecea3664f' to feed with ID '34b62e08-208e-4707-8ffa-f01613f74e2e'.
Successfully added image set with ID '16d84454-08d0-4b35-aa7c-4ebecea3664f' to feed with ID '34b62e08-208e-4707-8ffa-f01613f74e2e'.
Command completed successfully in 00:00:06.1590998.
```

### create

The **create** operation creates a new feed.

<details><summary>Flags</summary>
<p>

Flag | Description
-------|------
s, --chipskuid *GUID* | Specifies one or more chip SKU IDs that this feed targets. You can either use this flag multiple times to specify multiple SKUs or use the flag once and separate multiple SKU IDs with commas and no intervening spaces. Required.
-c, --componentid *GUID* |	Specifies the ID of the component that this feed delivers. The component must already have been created by either the cutil com create or cutil com addimage --autocreatecomponent command. Required.
-f, --dependentfeedid*GUID* |	Specifies the ID of the Azure Sphere OS feed on which this feed depends. Currently, applications must specify the Preview MT3620 Feed. To get a list of system software feeds and IDs, use the cutil feed list command. Required.
-n, --name *String* |	Specifies an alphanumeric name for the feed. Feed names must be unique within a tenant. Required.
-p, --productskuid *GUID* |	Specifies one or more product SKU IDs that this feed targets. You can either use this flag multiple times to specify multiple SKUs or use the flag once and separate multiple SKU IDs with commas and no intervening spaces. Required.
</p>
</details>

#### Examples

```sh
cutil feed create --name NewDocTestFeed --componentid  4275ecb3-5cf8-4147-9bfb-a7e8f3955e96 --chipSkuid 0d24af68-c1e6-4d60-ac82-8ba92e09f7e9 --productskuid ee4c1baa-1887-4da5-aaf9-76c0b59cda70 --dependentfeedid edd33e66-9b68-44c8-9d23-eb60f2e5018b 

Creating feed with name 'NewDocTestFeed'.
Successfully created feed 'NewDocTestFeed' with ID 'fa1c6849-dd43-48bb-be91-199b731ea392'.
Command completed successfully in 00:00:08.0771186.
```

### get

The **get** operation returns information about a feed.

<details><summary>Flags</summary>
<p>

Flag | Description
-------| ------
-im --feedud *GUID* | Specifies the GUID that identifies the feed. Required 
</p>
</details>

#### Example

```sh
cutil feed get --feedid 8d297fc2-4c1b-4b81-9332-94e09f2bf0dd

Getting feed with ID '8d297fc2-4c1b-4b81-9332-94e09f2bf0dd'.
Retrieved feed 'DocTestFeed' of type 'ThirdPartyApplicationFeed' with ID '8d297fc2-4c1b-4b81-9332-94e09f2bf0dd'.
- SKU sets supported by this feed:
   -> '9d606c43-1fad-4990-b207-554a025e0869, ee4c1baa-1887-4da5-aaf9-76c0b59cda70'
- Targeted Component ID: 'a13c14a3-7b62-41c8-9495-90471c4b87aa'.
- Feeds this feed depends on:
   -> 7bb28182-50e9-41f4-a357-1d672ba3bdd6
- Image sets in feed:
   -> [e88b0fb2-fa0e-4f2c-a68e-8a8c4b9bffd1] 'DocTestBlink'.
Command completed successfully in 00:00:05.4338008.
```

### list

The **list** operation lists all feeds in the current tenant.

#### Example

```sh
cutil feed list

Listing all feeds.
Retrieved feeds:
--> [8d297fc2-4c1b-4b81-9332-94e09f2bf0dd] 'DocTestFeed'
--> [07de0226-5f7e-40de-87ef-6ea6838322c6] 'Preview MT3620 Secure World Feed'
--> [f730c6d6-fe0f-49b2-89a1-852e7aedb471] 'Preview MT3620 Normal World Feed'
--> [7bb28182-50e9-41f4-a357-1d672ba3bdd6] 'Preview MT3620 System Apps Feed'
Command completed successfully in 00:00:05.4238794.
```

### listdevicegroups

The **listdevicegroups** operation lists all device groups to which a feed is assigned.

<details><summary>Flags</summary>
<p>

Flag | Description
-------| ------
-i, --feedid *GUID* |	Specifies the GUID that identifies the feed. Required. 
</p>
</details>

#### Example

```sh
cutil feed listdevicegroups --feedid 8d297fc2-4c1b-4b81-9332-94e09f2bf0dd

Listing all device groups targeted by feed '8d297fc2-4c1b-4b81-9332-94e09f2bf0dd'.
Retrieved device groups targeted by feed '8d297fc2-4c1b-4b81-9332-94e09f2bf0dd':
--> Group 'DocMT' (ID: fbb064a6-df8d-4d21-8a45-d4ff0fb8de95) targets SKU set '9d606c43-1fad-4990-b207-554a025e0869, ee4c1baa-1887-4da5-aaf9-76c0b59cda70'
Command completed successfully in 00:00:04.6317958.
```

### listimagesets

The **listimagesets** operation lists all image sets that are assigned to a particular feed.

<details><summary>Flags</summary>
<p>

Flag | Description
----|----
-i, --feedid *GUID* | Specifies the GUID that identifies the feed. Required.
</p>
</details>



#### Example

```sh
cutil feed listimagesets --feedid 8d297fc2-4c1b-4b81-9332-94e09f2bf0dd

Listing all image sets in feed '8d297fc2-4c1b-4b81-9332-94e09f2bf0dd'.
Retrieved 1 image sets for feed '8d297fc2-4c1b-4b81-9332-94e09f2bf0dd':
--> {
  "Id": "e88b0fb2-fa0e-4f2c-a68e-8a8c4b9bffd1",
  "FriendlyName": "DocTestBlink"
}
Command completed successfully in 00:00:04.8182373.
```

## imageset

The **imageset** command creates and manages image sets.

Operation | Description
-------| ------ 
create | Creates an image set.
get |	Returns information about an image set.
list |	Lists all image sets in the current tenant.

### create

The **create** operation creates a new image set.

<details><summary>Flags</summary>
<p>

Flag | Description
----|----
-m, --imageid *GUID* | Specifies one or more image IDs that identify the images that the image set contains. You can either use this flag multiple times to specify multiple images or use the flag once and separate multiple image IDs with commas and no intervening spaces. Currently, image sets for applications can include only one image. Required.
-n, --name *String* | Supplies an alphanumeric name for the image set. Image set names must be unique within a tenant. Required.

</p>
</details>

#### Example

```
cutil imageset create -n DocTestImageset -m dc59be07-1feb-4be9-a5dc-42664dba4871

Adding new image set.
Successfully created image set 'DocTestImageset' with ID '12a6b409-4bec-432b-bfe6-19dac5553ab5'.
Command completed successfully in 00:00:05.7898800.`
```

### get

The **get** operation returns information about an image set.

<details><summary>Flags</summary>
<p>

Flag | Description
-------| ------ 
-i, --imagesetid *GUID* |	Specifies the GUID that identifies the image set. Required. 
</p>
</details>

#### Example

```sh
cutil imageset get -i 12a6b409-4bec-432b-bfe6-19dac5553ab5

Getting image set with ID '12a6b409-4bec-432b-bfe6-19dac5553ab5'.
Successfully retrieved image set '12a6b409-4bec-432b-bfe6-19dac5553ab5':
 --> ID:   [12a6b409-4bec-432b-bfe6-19dac5553ab5]
 --> Name: 'DocTestImageset'
Images to be installed:
 --> [ID: dc59be07-1feb-4be9-a5dc-42664dba4871]
Command completed successfully in 00:00:05.0161334.
```

### list

The **list** operation lists all image sets in the current tenant.

#### Example

```sh
cutil imageset list
Getting all image sets.
Successfully retrieved image sets:
 --> [96650483-8944-4abc-9237-215db3b660dc] 'MyIoTHubApp'
 --> [51263b54-f5ee-439b-9897-77ebcf659a87] 'MyIoTHubAppV2'
 Command completed successfully in 00:00:03.3124589.
```

## login

The **login** option provides login to the Azure Sphere tenant.

When you use **cutil**, the Azure Sphere services verify your identity by using Microsoft Azure Active Directory (AAD). AAD uses Single Sign-On (SSO), which  typically defaults to an existing identity on your PC. If this identity is not valid for use with the Azure Sphere tenant, **cutil** commands may fail.

The **cutil login** command enables you to sign in explicitly to Azure Sphere services. Upon success, this identity is used for subsequent **cutil** commands. In most cases, you should only have to sign in once.

#### Example

`cutil login`

In response, you should see a dialog box that lists your credentials or prompts you to log in. If the list includes the identity that you use for Azure Sphere, choose that identity. If not, enter the appropriate credentials. 

## sku

The **sku** command creates and manages SKUs.

Operation | Description
-------| ------ 
create |	Creates a SKU.
get |	Returns information about a SKU.
list |	Lists all SKUs.

### create

The **create** operation creates a new product SKU and associates a friendly name with it.

<details><summary>Flags</summary>
<p>

Flag |  Description
-------| ------
-d, --description *String* |	Provides a description of the SKU.
-n, --name *SkuName* |	Supplies an alphanumeric name for the SKU. SKU names are case sensitive and must be unique within a tenant. Required. 
</p>
</details>


#### Examples

```sh
cutil sku create -n DW100SKU -d "Contoso DW100 models"

Created SKU 'DW100SKU' with ID '1c68b7fa-f7ad-4019-8877-61abda864ada'.
Command completed successfully in 00:00:05.7252534.
```

### get

The **get** operation displays information about a SKU.

#### Flags

<table>
<tbody>
<tr class="odd">
<td>-i, --skuid <em>GUID</td>
<td>Specifies the GUID that identifies the SKU. Required. </td>
</tr>
</tbody>
</table>

#### Example

```sh
cutil sku get -i 1c68b7fa-f7ad-4019-8877-61abda864ada

Getting details for SKU with ID '1c68b7fa-f7ad-4019-8877-61abda864ada'.
Retrieved SKU:
 --> ID:          1c68b7fa-f7ad-4019-8877-61abda864ada
 --> Name:        'DW100SKU'
 --> Description: 'Contoso DW100 models'
 --> Type:        'Product'
Command completed successfully in 00:00:05.3542928.
```

### list

The **list** operation displays all the SKUs and names that are associated with the current tenant.

#### Example

```sh
cutil sku list

Listing all SKUs.
Retrieved SKUs:

ID                                   Name           SkuType
--                                   ----           -------
062eaa0d-2c7f-43c5-8921-2eb228d019ce new-test-sku   Product
ee4c1baa-1887-4da5-aaf9-76c0b59cda70 DocTestSKU     Product
1c68b7fa-f7ad-4019-8877-61abda864ada DW100SKU       Product
0d24af68-c1e6-4d60-ac82-8ba92e09f7e9 MT3620 A1 16MB Chip

Command completed successfully in 00:00:05.4358100.
```
