// SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "../common/IDataChunkCompilerV2.sol";

contract Sample1 is ERC721("Sample1", "SAMPLE1"), Ownable {
    using Strings for uint256;

    IDataChunkCompilerV2 private compiler;
    address[9] private threeAddresses;
    string private constant STYLE_CODE =
        "%253Cstyle%253E%252A%257Bmargin%253A0%253Bpadding%253A0%257Dcanvas%257Bwidth%253A100%2525%253Bheight%253A100%2525%257D%253C%252Fstyle%253E";
    string private constant JS_CODE =
        "window.onload%253D()%253D%253E%257Bconst%2520e%253Dnew%2520THREE.Scene%252Cn%253D(e.background%253Dnew%2520THREE.Color(16777215)%252Cnew%2520THREE.PerspectiveCamera(75%252Cwindow.innerWidth%252Fwindow.innerHeight%252C.1%252C1e3))%252Co%253Dnew%2520THREE.WebGLRenderer%253Bo.setSize(window.innerWidth%252Cwindow.innerHeight)%252Cdocument.body.appendChild(o.domElement)%253Bvar%2520i%253Dnew%2520THREE.HemisphereLight(16777215%252C2105376%252C1)%252Cr%253Dnew%2520THREE.TorusKnotGeometry(1%252C.3%252C100%252C16%252C2%252C3)%252Ct%253Dnew%2520THREE.MeshPhongMaterial(%257Bcolor%253A65535%257D)%253Bfunction%2520d()%257BrequestAnimationFrame(d)%252Cw.rotation.x%252B%253D.01%252Cw.rotation.y%252B%253D.01%252Co.render(e%252Cn)%257Dconst%2520w%253Dnew%2520THREE.Mesh(r%252Ct)%253Be.add(i%252Cw)%252Cn.position.z%253D4%253Bd()%257D%253B";

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

    function mint(uint256 tokenId) public onlyOwner {
        _mint(msg.sender, tokenId);
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
                        // var tokenId
                        compiler.BEGIN_SCRIPT(),
                        compiler.SCRIPT_VAR("tokenId", tokenIdStr, true),
                        compiler.END_SCRIPT(),
                        // main script
                        compiler.BEGIN_SCRIPT(),
                        JS_CODE,
                        compiler.END_SCRIPT()
                    ),
                    compiler.END_METADATA_VAR(false)
                ),
                string.concat(compiler.BEGIN_METADATA_VAR("name", false), name(), "%20", tokenIdStr, "%22"),
                compiler.END_JSON()
            );
    }
}
