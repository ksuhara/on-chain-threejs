// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2022 nawoo (@NowAndNawoo)

pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "../common/IDataChunkCompilerV2.sol";

contract Sample4 is ERC721("Sample4", "SAMPLE4"), Ownable {
    using Strings for uint256;

    IDataChunkCompilerV2 private compiler;
    address[2] private imageAddresses;
    address[9] private threeAddresses;
    string private constant STYLE_CODE =
        "%253Cstyle%253E%252A%257Bmargin%253A0%253Bpadding%253A0%257Dcanvas%257Bwidth%253A100%2525%253Bheight%253A100%2525%257D%253C%252Fstyle%253E";
    string private constant JS_CODE =
        "window.onload%253D()%253D%253E%257Bconst%2520e%253D%257Bwidth%253Awindow.innerWidth%252Cheight%253Awindow.innerHeight%257D%252Ci%253Dnew%2520THREE.Scene%252Ct%253Dnew%2520THREE.PerspectiveCamera(75%252Ce.width%252Fe.height%252C.1%252C1e3)%252Cn%253D(t.position.z%253D2%252Ct.position.y%253D1%252Ct.lookAt(0%252C0%252C0)%252Cnew%2520THREE.WebGLRenderer)%253Bn.setSize(e.width%252Ce.height)%252Cn.setPixelRatio(window.devicePixelRatio)%252Cdocument.body.appendChild(n.domElement)%253Bvar%2520o%253Dnew%2520THREE.SphereGeometry(1%252C80%252C40)%252Cd%253D(new%2520THREE.TextureLoader).load(imageUrl)%252Cd%253Dnew%2520THREE.MeshStandardMaterial(%257Bmap%253Ad%257D)%253Bd.roughness%253D.4%253Bconst%2520w%253Dnew%2520THREE.Mesh(o%252Cd)%253Bo%253Dnew%2520THREE.AmbientLight(2105376)%252Cd%253Dnew%2520THREE.PointLight%253Bd.position.set(2%252C2%252C2)%252Ci.add(w%252Co%252Cd)%252Cwindow.addEventListener(%2522resize%2522%252C()%253D%253E%257Be.width%253Dwindow.innerWidth%252Ce.height%253Dwindow.innerHeight%252Ct.aspect%253De.width%252Fe.height%252Ct.updateProjectionMatrix()%252Cn.setSize(e.width%252Ce.height)%252Cn.setPixelRatio(window.devicePixelRatio)%257D)%253Bfunction%2520h()%257BrequestAnimationFrame(h)%252Cw.rotation.y%252B%253D.1*a.getDelta()%252Cn.render(i%252Ct)%257Dconst%2520a%253Dnew%2520THREE.Clock%253Bh()%257D%253B";

    function setCompilerAddress(address newAddress) public onlyOwner {
        compiler = IDataChunkCompilerV2(newAddress);
    }

    function setThreeAddress(
        address chunk1,
        address chunk2,
        address chunk3,
        address chunk4,
        address chunk5,
        address chunk6,
        address chunk7,
        address chunk8,
        address chunk9
    ) public onlyOwner {
        threeAddresses[0] = chunk1;
        threeAddresses[1] = chunk2;
        threeAddresses[2] = chunk3;
        threeAddresses[3] = chunk4;
        threeAddresses[4] = chunk5;
        threeAddresses[5] = chunk6;
        threeAddresses[6] = chunk7;
        threeAddresses[7] = chunk8;
        threeAddresses[8] = chunk9;
    }

    function setImageAddress(address chunk1, address chunk2) public onlyOwner {
        imageAddresses[0] = chunk1;
        imageAddresses[1] = chunk2;
    }

    function mint(uint256 tokenId) public onlyOwner {
        _mint(msg.sender, tokenId);
    }

    function getImageData() private view returns (string memory) {
        return compiler.compile2(imageAddresses[0], imageAddresses[1]);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory threejs = compiler.compile9(
            threeAddresses[0],
            threeAddresses[1],
            threeAddresses[2],
            threeAddresses[3],
            threeAddresses[4],
            threeAddresses[5],
            threeAddresses[6],
            threeAddresses[7],
            threeAddresses[8]
        );
        string memory tokenIdStr = tokenId.toString();
        string memory image = getImageData();
        return
            string.concat(
                compiler.BEGIN_JSON(),
                string.concat(
                    compiler.BEGIN_METADATA_VAR("animation_url", false),
                    compiler.HTML_HEAD(),
                    STYLE_CODE,
                    string.concat(
                        // Three.js
                        compiler.BEGIN_SCRIPT_DATA_COMPRESSED(),
                        threejs,
                        compiler.END_SCRIPT_DATA_COMPRESSED()
                    ),
                    string.concat(
                        // variables
                        compiler.BEGIN_SCRIPT(),
                        compiler.SCRIPT_VAR("tokenId", tokenIdStr, true),
                        compiler.SCRIPT_VAR("imageUrl", image, false),
                        compiler.END_SCRIPT(),
                        // main script
                        compiler.BEGIN_SCRIPT(),
                        JS_CODE,
                        compiler.END_SCRIPT()
                    ),
                    compiler.END_METADATA_VAR(false)
                ),
                string.concat(compiler.BEGIN_METADATA_VAR("name", false), name(), "%20%23", tokenIdStr, "%22"),
                compiler.END_JSON()
            );
    }
}
