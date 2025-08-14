
# UBI STIG Remediation Example 🛡️

This repository demonstrates how to generate and apply a STIG (Security Technical Implementation Guide) remediation to the **UBI9 (Universal Base Image)**. Following this process results in approximately 90% of the security rules passing. The remaining failures, typically three medium-severity rules, are generally considered irrelevant within containerized environments.

-----

## Scanning the Base Image

To scan the UBI9 image and generate a STIG compliance report, use the following command:

```bash
oscap-podman [image_id] xccdf eval \
--profile "xccdf_org.ssgproject.content_profile_stig" \
--report report-stig.html \
--results results-stig.xml \
ssg-rhel9-ds.xml
```

-----

## Finding the Result ID

After the scan, you need to identify the specific result ID to generate the remediation script. You can find this ID by inspecting the results file:

```bash
oscap info results-stig.xml
```

**Example Result:** `xccdf_org.open-scap_testresult_xccdf_org.ssgproject.content_profile_stig`

-----

## Generating the Remediation Script

Use the identified result ID to generate a **Bash script** (`ubi-stig.sh`) that will apply the necessary security fixes.

```bash
oscap xccdf generate fix --fix-type bash \
--output ubi-stig.sh \
--result-id xccdf_org.open-scap_testresult_xccdf_org.ssgproject.content_profile_stig \
results-stig.xml
```

-----

## Applying Remediation in a Containerfile

Integrate the generated script into your **Containerfile** to create a hardened image. The script is added and executed during the build process, then removed to keep the final image clean.

```dockerfile
FROM registry.access.redhat.com/ubi9/ubi
ADD ubi-stig.sh /
RUN ./ubi-stig.sh && rm -f /ubi-stig.sh
```

**Example Hardened Image:** `quay.io/mrguitar/ubi9:stig`

-----

## More Comprehensive Example

For a more detailed and thorough example of UBI9 STIG remediation, refer to the official repository:

  * **[https://repo1.dso.mil/dsop/redhat/ubi/9.x/ubi9](https://repo1.dso.mil/dsop/redhat/ubi/9.x/ubi9)**
