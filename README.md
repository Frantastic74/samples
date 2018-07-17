---
title: Azure Sphere installation and setup
description: Walks you through setting up your PC and development environment for creating Azure Sphere applications.
author:  pennyo 
ms.topic:  quickstart
ms.author: azurespheredocs
ms.prod: azure-sphere
ms.technology: azure-sphere 
---
# Azure Sphere Installation and Setup

This document walks you through setting up your PC and development environment, and using a development board to develop applications. In addition, it demonstrates how to load and build Azure Sphere sample applications with Visual Studio.

## Set up your machine for Azure Sphere development

To connect to a reference development board (RDB), your development PC requires the following:

-   Windows 10 Anniversary Update or later

-   Support for the [Visual Studio 2017 System Requirements](https://www.visualstudio.com/en-us/productinfo/vs2017-system-requirements-vs)

-   A USB port

### Connect the RDB

The RDB connects to a PC through a USB micro-connector. When plugged in, the RDB exposes three COM ports.

The first time you plug in the board, the drivers should be automatically downloaded and installed. Installation can be slow; if the drivers are not installed automatically, right-click on the device name in Device Manager and select **Update driver**. Alternatively, you can download the drivers from [Future Technology Devices International](http://www.ftdichip.com/Drivers/VCP.htm) ([FTDI](http://www.ftdichip.com/Drivers/VCP.htm)). Choose the driver that matches your Windows installation (32- or 64-bit).

To verify installation, open **Device Manager** and look for three COM ports:

![Device Manager with three COM ports](../media/devmgrcomports.png)

<span id="_Install_the_TAP" class="anchor"></span>

### Install the TAP driver

The development board communicates with the PC over serial line internet protocol (SLIP). Tap-Windows provides a network interface driver for SLIP.

**To install TAP and enable SLIP communication**

1. Install TAP-Windows, which came with your Azure Sphere software development kit (SDK).

2. In the installation options, choose **TAP Virtual Ethernet Adapter** and **TAP Utilities**, but not TAP SDK.

   ![Select TAP components to install](../media/tapinstall.png)

3. If you are asked to authorize installation of the driver, select **Install**.

   ![Confirm TAP installation](../media/tapconfirm.png)

### Configure TAP networking

After you install the driver, configure TAP networking for the board.

**Note:** You must have administrator rights to the PC to set the properties in steps 3 and 4.

**To configure TAP networking**

1. In Control Panel, type **View Network Connections** in the search box, and click to open the Network Connections dialog box. Find the TAP-Windows Adapter V9.

   ![TAP before rename](../media/tapb4rename.PNG)

2. Select **TAP-Windows Adapter v9** and rename it to **sl0** (lower case S, lower case L, the number zero):

   ![Rename TAP to sl0](../media/sl0.png) 

3. Open **Properties** for **sl0** and disable all services except Internet Protocol Version 4 (TCP/IPv4):

   ![Set sl0 properties](../media/sl0properties.png)

4. Select **Properties** for TCP/IPv4 and configure it to use the IP address 192.168.35.1, subnet mask 255.255.255.0:

   ![TCP/IP properties for sl0](../media/tcpipproperties.png) 

5. Click **OK**.

## Install Visual Studio 2017 version 15.6 or later

The Visual Studio Tools for Azure Sphere require Visual Studio Enterprise, Professional, or Community 2017 version 15.6 or later. To verify which version is installed, start the Visual Studio Installer and make sure that the version number is 15.6.0 or later. If the installer prompts you to update the Visual Studio Installer, do so.

To install Visual Studio, click [Download Visual Studio](http://www.visualstudio.com), select the edition to install, and then run the installer. You can choose to install any workloads, or none. The Visual Studio Tools for Azure Sphere installation procedure automatically installs the workloads that the SDK requires.

## Install the Visual Studio Tools Preview for Azure Sphere

The Visual Studio Tools Preview for Azure Sphere includes:

-   A custom Azure Sphere Developer Command Prompt, which is available in the **Start** menu under Azure Sphere

-   The GDB debugger for use with the Azure Sphere development board

-   Device, cloud, and image utilities

-   Libraries for application development

-   Visual Studio extensions to support Azure Sphere development

VS\_Tools\_Preview\_for\_Azure\_Sphere.exe installs the complete Azure Sphere software development kit (SDK).

**To install the Visual Studio Tools Preview for Azure Sphere**

1. Run VS\_Tools\_Preview\_for\_Azure\_Sphere.exe, which came with your Azure Sphere development kit, to install the developer tools. Agree to the license terms and select **Install**. Accept the elevation prompt if you see one.

   ![Developer Tools setup box](../media/devtoolsinstall.png)

    If you have just installed Visual Studio for the first time, you might see the message, "No product to install SDK on." If this occurs, restart your PC and return to this step.

2. In the VSIX Installer window, confirm the Visual Studio version(s) for which to install the tools.

3. Accept the elevation prompt.

4. After installation starts, find the VSIX Installer window and bring it to the front. The installation process displays two installation windows: the Visual Studio Tools Preview for Azure Sphere window and the VSIX Installer window. The former reports progress and errors from the overall installation, and the latter reports information about the Visual Studio extension only. If the VSIX window becomes obscured during installation, you might not see error reports or requests for action.

5. When setup completes, select **Close** in both the VSIX Installer window and the Visual Studio Tools Preview for Azure Sphere setup window.

If the installer returns errors, try uninstalling and then reinstalling the tools. To uninstall the tools, use **Add and Remove Programs** in **Control Panel**.

## Update your device software

> [!NOTE]
> Placeholder for update for new users during Quickstart. We'll need an update page for existing users too. 
> 

## Create an Azure Sphere tenant

> [!NOTE]
> Placeholder for tenant creation. Currently it's a docx file that's specific to those with engagements in Collaborate. How much tenant creation info do we want here? 

## Claim your device

<span id="_Hlk489428344" class="anchor"></span>After you install Visual Studio and the SDK, you must *claim* your device. Claim your device only once.

Every device has a unique and immutable Azure Sphere device ID that the Azure Sphere security service uses to identify and authenticate it. Claiming the device associates its Azure Sphere device ID with your Azure Sphere tenant. 

Before you claim a device, be sure that you are logged in to the tenant that you plan to use with Azure Sphere services. See the **cutil login** command in the *Command-line Utilities Reference* for more information. 

**To claim your device**

1. Connect your board to the PC by USB.

2. Open an Azure Sphere Developer Command Prompt. To find the Azure Sphere Developer Command Prompt, click the **Start** button and type **Azure Sphere**.

3. Run the **cutil** cloud utility with the **device** command as follows:

   `cutil device claim --attached`

   This command reads the Azure Sphere device ID from the board and associates it with your current tenant. If you are prompted to log in to Microsoft Azure, do so using your Azure Sphere credentials.

   *You should see output like this:*

   ```sh

   Claiming device.
   Claiming attached device ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED' into tenant ID 'd343c263-4aa3-4558-adbb-d3fc34631800'.
   Successfully claimed device ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED' into tenant ID 'd343c263-4aa3-4558-adbb-d3fc34631800'.
   Command completed successfully in 00:00:05.5459143.
   ```

**Troubleshooting:**

If **cutil** returns the following message, your device might not be correctly installed or configured:

`An error occurred. Please check your device is connected and your PC has been configured correctly, then retry.` 

This message can appear in several circumstances:

- The board is not connected by USB to the PC.
- The TAP driver is not installed.
- The IP address is not set correctly. 
- The Azure Sphere Device Communication Service has not yet started. 
 
Try the following solutions, in order:

1.	Ensure that the device is connected by USB to the PC. 
2.	If the device is connected, press the Reset button on the device. Wait ten seconds or so for the device to restart, and then issue the failed command again.
3.	If the command again reports that it cannot find the device, unplug the device from the USB connector, plug it in again, and wait for it to restart. 
4.	If the error recurs after restart, use **View Network Connections** in **Control Panel** to check that the sl0 device exists and is configured to use IP address 192.168.35.1.

## Prepare your device for development

Before you can run the sample applications on your Azure Sphere device or develop new applications for it, you must set it up for development and debugging. By default, Azure Sphere device security does not allow you to load applications from a PC; only the Azure Sphere Security Service can load applications. The **debugprep** command configures the device to accept applications from a PC for debugging.

1. Make sure that your PC is connected to the internet.

2. In an Azure Sphere Developer Command Prompt window, type the following command:

   `cutil device debugprep`

	You should see output similar to the following:

   ```sh
   Getting device capability configuration for application development.
   Downloading device capability configuration for device ID 'ABCDE082513B529C45098884F882B2CA6D832587CAAE1A90B1CEC4A376EA2F22A96C4E7E1FC4D2AFF5633B68DB68FF4420A5588B420851EE4F3F1A7DC51399ED'.
   Successfully downloaded device capability configuration.
   Successfully wrote device capability configuration file 'C:\Users\user\AppData\Local\Temp\tmpD732.tmp'.
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

## Next Steps

Your Azure Sphere device is now set up and ready for you to develop and debug applications. We recommend:

- Building your first application using the Blink template
- Configuring Wi-Fi on Azure Sphere so you can create an over-the-air (OTA) deployment
- Testing over-the air deployment with the Blink application 
