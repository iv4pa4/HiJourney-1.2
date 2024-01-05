// import { Test, TestingModule } from '@nestjs/testing';
// import { AdventurerController } from './adventurer.controller';
// import { AdventurerService } from './adventurer.service';
// import { Adventurer } from './adventurer.entity';
// import { Pagination, IPaginationMeta } from 'nestjs-typeorm-paginate';

// jest.mock('./adventurer.service');

// describe('AdventurerController', () => {
//   let controller: AdventurerController;
//   let adventurerService: AdventurerService;

//   beforeEach(async () => {
//     const module: TestingModule = await Test.createTestingModule({
//       controllers: [AdventurerController],
//       providers: [
//         {
//           provide: AdventurerService,
//           useValue: adventurerService, 
//         },
//       ],
//     }).compile();

//     controller = module.get<AdventurerController>(AdventurerController);
//     adventurerService = module.get<AdventurerService>(AdventurerService);
//   });

//   it('should be defined', () => {
//     expect(controller).toBeDefined();
//   });

//   it('should get all adventurers', async () => {
//     const adventurers: Adventurer[] = [{ id: 1, username: 'Adventurer 1', email: 'Email 1', password: 'Password 1' }];

 
//     const pagination: Pagination<Adventurer, IPaginationMeta> = {
//         items: adventurers,
//         links: {},
//         meta: { itemCount: adventurers.length, totalItems: adventurers.length, itemsPerPage: 10, totalPages: 1, currentPage: 1 },
//     };

//     jest.spyOn(adventurerService, 'findAll').mockResolvedValue(pagination);
//     expect(await controller.findAll({})).toBe(pagination);
//   });

//   it('should get a single adventurer', async () => {
//     const adventurerId = 1;
//     const adventurer: Adventurer = { id: adventurerId, username: 'Adventurer 1', email: 'email 1', password: ' password1'  };
//     jest.spyOn(adventurerService, 'getSingleAdventurer').mockResolvedValue(adventurer);
//     expect(await controller.getAdventurer(adventurerId.toString())).toBe(adventurer);
//   });

//   it('should create a new adventurer', async () => {
//     const adventurerDto = { username: 'New Adventurer', email: 'New email', password: 'New password' };
//     const createdAdventurer: Adventurer = { id: 1, ...adventurerDto };
//     jest.spyOn(adventurerService, 'create').mockResolvedValue(createdAdventurer);
//     expect(await controller.createAdventurer(adventurerDto)).toBe(createdAdventurer);
//   });

//   it('should update a adventurer', async () => {
//     const adventurerId = 1;
//     const adventurerDto = { username: 'Updated Adventurer', email: 'Updated email', password: 'Updated password' };
//     const updatedAdventurer: Adventurer = { id: adventurerId, ...adventurerDto };
//     jest.spyOn(adventurerService, 'update').mockResolvedValue(updatedAdventurer);
//     expect(await controller.updateAdventurer(adventurerId, adventurerDto)).toBe(updatedAdventurer);
//   });

//   it('should delete a adventurer', async () => {
//     const adventurerId = 1;
//     const deletedAdventurer: Adventurer = { id: adventurerId, username: 'Deleted Adventurer', email: 'Deleted email', password: 'Deleted password' };
//     jest.spyOn(adventurerService, 'deleteAdventurer').mockResolvedValue(deletedAdventurer);
//     expect(await controller.deleteAdventurer(adventurerId)).toBe(deletedAdventurer);
//   });
// });
