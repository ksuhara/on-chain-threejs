// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2022 nawoo (@NowAndNawoo)

pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "../common/IDataChunkCompilerV2.sol";

contract Sample2 is ERC721("Sample2", "SAMPLE2"), Ownable {
    using Strings for uint256;

    uint256 public nextTokenId = 1;
    IDataChunkCompilerV2 private compiler;
    address[9] private threeAddresses;
    string private constant STYLE_CODE =
        "%253Cstyle%253E%252A%257Bmargin%253A0%253Bpadding%253A0%257Dcanvas%257Bwidth%253A100%2525%253Bheight%253A100%2525%257D%253C%252Fstyle%253E";
    string private constant JS_CODE =
        "const%2520MAX_INT32%253D2147483647%253Bclass%2520Random%257Bconstructor(e)%257Be%253C%253D0%2526%2526(e%252B%253DMAX_INT32-1)%252Cthis._value%253De%252Cthis.int()%257Dint()%257Breturn%2520this._value%253D48271*this._value%2525MAX_INT32%252Cthis._value%257Dfloat()%257Breturn(this.int()-1)%252F(MAX_INT32-1)%257DintRange(e%252Ct)%257Breturn%2520Math.floor(this.floatRange(e%252Ct))%257DfloatRange(e%252Ct)%257Breturn%2520e%252B(t-e)*this.float()%257Dboolean()%257Breturn%2520this.int()%25252%253D%253D0%257Dcolor()%257Breturn%2520Math.floor(16777216*this.float())%257D%257Dwindow.onload%253D()%253D%253E%257Bvar%2520e%253Dnew%2520Random(tokenId)%252Ct%253De.color()%252Cn%253De.color()%252Co%253De.intRange(1%252C9)%252Ce%253De.intRange(1%252C9)%253Bconsole.log(%257BtokenId%253AtokenId%252CbgColor%253At%252CgeomColor%253An%252Cp%253Ao%252Cq%253Ae%257D)%253Bconst%2520i%253D%257Bwidth%253Awindow.innerWidth%252Cheight%253Awindow.innerHeight%257D%252Cr%253Dnew%2520THREE.Scene%252Ca%253D(r.background%253Dnew%2520THREE.Color(t)%252Cnew%2520THREE.PerspectiveCamera(75%252Ci.width%252Fi.height%252C.1%252C1e3))%252Ch%253D(a.position.z%253D4%252Ca.lookAt(0%252C0%252C0)%252Cnew%2520THREE.WebGLRenderer)%253Bh.setSize(i.width%252Ci.height)%252Ch.setPixelRatio(window.devicePixelRatio)%252Cdocument.body.appendChild(h.domElement)%253Bt%253Dnew%2520THREE.HemisphereLight(16777215%252C2105376%252C1)%252Co%253Dnew%2520THREE.TorusKnotGeometry(1%252C.2%252C200%252C32%252Co%252Ce)%252Ce%253Dnew%2520THREE.MeshPhongMaterial(%257Bcolor%253An%257D)%253Bfunction%2520d()%257BrequestAnimationFrame(d)%253Bvar%2520e%253Dw.getDelta()%253Bl.rotation.x%252B%253De%252Cl.rotation.y%252B%253De%252Ch.render(r%252Ca)%257Dconst%2520l%253Dnew%2520THREE.Mesh(o%252Ce)%252Cw%253D(r.add(t%252Cl)%252Cwindow.addEventListener(%2522resize%2522%252C()%253D%253E%257Bi.width%253Dwindow.innerWidth%252Ci.height%253Dwindow.innerHeight%252Ca.aspect%253Di.width%252Fi.height%252Ca.updateProjectionMatrix()%252Ch.setSize(i.width%252Ci.height)%252Ch.setPixelRatio(window.devicePixelRatio)%257D)%252Cnew%2520THREE.Clock)%253Bd()%257D%253B";

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

    function mint() public {
        uint256 _tokenId = nextTokenId;
        nextTokenId++;
        _mint(msg.sender, _tokenId);
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
                        // variable
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
                string.concat(compiler.BEGIN_METADATA_VAR("name", false), name(), "%20%23", tokenIdStr, "%22"),
                compiler.END_JSON()
            );
    }
}
